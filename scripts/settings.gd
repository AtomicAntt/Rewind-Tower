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

var master_value: float
var music_value: float
var sfx_value: float

func _ready() -> void:
	master_knob = %Master
	music_knob = %Music
	sfx_knob = %SFX
	
	master_percent_text = %MasterPercent
	music_percent_text = %MusicPercent
	sfx_percent_text = %SFXPercent
	
	master_value = SettingsHandler.get_master()
	music_value = SettingsHandler.get_music()
	sfx_value = SettingsHandler.get_sfx()
	
	master_knob.value = master_value
	music_knob.value = music_value
	sfx_knob.value = sfx_value

func _process(_delta: float) -> void:
	master_percent_text.text = str(master_knob.value)
	music_percent_text.text = str(music_knob.value)
	sfx_percent_text.text = str(sfx_knob.value)
	
	var master_percent: int = remap(master_value, -10, 10, 0, 100)
	var music_percent: int = remap(music_value, -10, 10, 0, 100)
	var sfx_percent: int = remap(sfx_value, -10, 10, 0, 100)
	
	master_value = master_knob.value
	music_value = music_knob.value
	sfx_value = sfx_knob.value
	
	SettingsHandler.set_master(master_value)
	SettingsHandler.set_music(music_value)
	SettingsHandler.set_sfx(sfx_value)
	
	SettingsHandler.save()
	
	master_percent_text.text = str(master_percent)
	music_percent_text.text = str(music_percent)
	sfx_percent_text.text = str(sfx_percent)
	
	AudioServer.set_bus_volume_db(0, master_value)
	AudioServer.set_bus_volume_db(1, music_value)
	AudioServer.set_bus_volume_db(2, sfx_value)
	
	
	if master_value < -9.5:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)

	if music_value < -9.5:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)

	if sfx_value < -9.5:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		
