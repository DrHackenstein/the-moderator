extends Node

var saves : ConfigFile
var loaded : bool = false

func _ready():
	load_save()


func load_save():
	if( loaded ):
		return
	loaded = true
	saves = ConfigFile.new()
	var load = saves.load("user://saves.cfg")

func reset_saves():
	load_save()
	print("Reset saves")
	saves.clear()
	saves.save("user://saves.cfg")


func save_start(id : String):
	load_save()
	print("Save: ", id)
	saves.set_value("main", "start", id)
	saves.save("user://saves.cfg")
	
func load_start(default : String):
	load_save()
	return saves.get_value("main", "start", default)


func save_time(hour : int, minute : int):
	load_save()
	saves.set_value("main", "hour", hour)
	saves.set_value("main", "minute", minute)
	saves.save("user://saves.cfg")
	
func load_time(default_hour : int, default_minute : int):
	load_save()
	return [saves.get_value("main", "hour", default_hour), saves.get_value("main", "minute", default_minute)]

