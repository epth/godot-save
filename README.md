# godot-save
save script for Godot,including multiple method to save data

How to Use:

1-1.If you just want to load data to exists node,you should add code to which node want to save:

```gdscript
func save():
	var save_dict = {
		'method_type' : SAVE.METHOD_TYPE.MODIFY,
		'path' :get_path(),
		'value':value,
	}
	return save_dict
```
  
 1-2.If you want to totaly replace node while loading data,should add code to which node want to save:
 
 ```gdscript
 func save():
    var save_dict = {
        'method_type' : SAVE.METHOD_TYPE.INSTANCE,
        "filename" : get_filename(),
        "parent" : get_parent().get_path(),
        "pos_x" : position.x, # Vector2 is not supported by JSON
        "pos_y" : position.y,
        "attack" : attack,
        "defense" : defense,
        "current_health" : current_health,
        "max_health" : max_health,
        "damage" : damage,
        "regen" : regen,
        "experience" : experience,
        "tnl" : tnl,
        "level" : level,
        "attack_growth" : attack_growth,
        "defense_growth" : defense_growth,
        "health_growth" : health_growth,
        "is_alive" : is_alive,
        "last_attack" : last_attack
    }
    return save_dict
```

   2.Call save_game and load_game in any where:

```gdscript

   var save=SAVE.new()
   save.save_game()
   ＃or
   save.load_game()
```


Refrence:
https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
