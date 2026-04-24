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
	return config.get_value("AUDIO","master_volume", master_default)

func get_music() -> float:
	return config.get_value("AUDIO","music_volume", music_default)

func get_sfx() -> float:
	return config.get_value("AUDIO","sfx_volume", sfx_default)

func set_turn_mode(value: int):
	config.set_value("CONTROLS","turn_mode",value)

func get_turn_mode() -> int:
	return config.get_value("CONTROLS","turn_mode", 0)

func set_smooth_speed(value: int):
	config.set_value("CONTROLS","smooth_speed",value)

func get_smooth_speed() -> int:
	return config.get_value("CONTROLS","smooth_speed", 2)

func set_table_height(value: float):
	config.set_value("GENERAL","table_height",value)

func get_table_height() -> float:
	return config.get_value("GENERAL","table_height", 0)


func _ready() -> void:
	config.load(path)
	
	save()
