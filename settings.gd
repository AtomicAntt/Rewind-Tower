extends Node
class_name Settings

var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")

var master_knob: KnobInteractable
var music_knob: KnobInteractable
var sfx_knob: KnobInteractable

var master_percent_text: Label3D
var music_percent_text: Label3D
var sfx_percent_text: Label3D

var volume_min: int = -30
var volume_max: int = 10

func _ready() -> void:
	master_knob = %Master
	music_knob = %Music
	sfx_knob = %SFX
	
	master_percent_text = %MasterPercent
	music_percent_text = %MusicPercent
	sfx_percent_text = %SFXPercent

func _process(_delta: float) -> void:
	master_percent_text.text = str(master_knob.twister_value)
	music_percent_text.text = str(music_knob.twister_value)
	sfx_percent_text.text = str(sfx_knob.twister_value)
	
	var master_value = clamp(master_knob.twister_value, volume_min, volume_max)
	var music_value = clamp(music_knob.twister_value, volume_min, volume_max)
	var sfx_value = clamp(sfx_knob.twister_value, volume_min, volume_max)
	
	var master_percent = master_value * 2.5
	var music_percent = music_value * 2.5
	var sfx_percent = sfx_value * 2.5
	
	#AudioServer.set_bus_volume_db(0, master_percent)
	#AudioServer.set_bus_volume_db(1, music_percent)
	#AudioServer.set_bus_volume_db(2, sfx_percent)
