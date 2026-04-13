extends Node

var config: ConfigFile = ConfigFile.new()
var path: String = "user://config.cfg"


func save():
	config.save(path)
	
func set_master(value: float):
	config.set_value("AUDIO","master_volume",value)
	
func set_music(value: float):
	config.set_value("AUDIO","music_volume",value)
	
func set_sfx(value: float):
	config.set_value("AUDIO","sfx_volume",value)
	
func get_master() -> float:
	if config.get_value("AUDIO","master_volume") != null:
		return config.get_value("AUDIO","master_volume")
	return 10
func get_music() -> float:
	if config.get_value("AUDIO","music_volume") != null:
		return config.get_value("AUDIO","music_volume")
	return 3
	
func get_sfx() -> float:
	if config.get_value("AUDIO","sfx_volume") != null:
		return config.get_value("AUDIO","sfx_volume")
	return 8

func _ready() -> void:
	config.load(path)
	
	save()
