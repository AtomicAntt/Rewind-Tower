extends Node

var config: ConfigFile = ConfigFile.new()
var path: String = "user://config.cfg"

var master_default: float = 10
var music_default: float = -7.88
var sfx_default: float = 2.199

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
	return master_default
func get_music() -> float:
	if config.get_value("AUDIO","music_volume") != null:
		return config.get_value("AUDIO","music_volume")
	return music_default
	
func get_sfx() -> float:
	if config.get_value("AUDIO","sfx_volume") != null:
		return config.get_value("AUDIO","sfx_volume")
	return sfx_default

func set_turn_mode(value: int):
	config.set_value("CONTROLS","turn_mode",value)

func get_turn_mode() -> int:
	if config.get_value("CONTROLS","turn_mode") != null:
		return config.get_value("CONTROLS","turn_mode")
	return 0

func set_smooth_speed(value: int):
	config.set_value("CONTROLS","smooth_speed",value)

func get_smooth_speed() -> int:
	if config.get_value("CONTROLS","smooth_speed") != null:
		return config.get_value("CONTROLS","smooth_speed")
	return 2

func _ready() -> void:
	config.load(path)
	
	save()
