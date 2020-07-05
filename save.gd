extends Node

class_name SAVE

enum METHOD_TYPE{
	INSTANCE,
	MODIFY,
}

var ignore_key=['filename','parent','pos_x','pos_y','method_type','path']

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
			
		# Check the node has a save function
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		
		var new_object
		match int(node_data["method_type"]):
			METHOD_TYPE.INSTANCE:
				# Firstly, we need to create the object and add it to the tree and set its position.
				new_object = load(node_data["filename"]).instance()
				get_node(node_data["parent"]).add_child(new_object)
				new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
				for i in node_data.keys():
					if i in ignore_key:
						continue
					new_object.set(i, node_data[i])
				
			METHOD_TYPE.MODIFY:
				new_object=get_node(node_data['path'])
				for i in node_data.keys():
					if i in ignore_key:
						continue
					new_object.set(i, node_data[i])
	save_game.close()
	pass
