extends Node
class_name Settings

var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")

var master_knob: KnobInteractable
var music_knob: KnobInteractable
var sfx_knob: KnobInteractable

var volume_min: int = -30
var volume_max: int = 10

var master_value: float
var music_value: float
var sfx_value: float

@onready var master_wheel: Node3D = %MasterWheel
@onready var music_wheel: Node3D = %MusicWheel
@onready var sfx_wheel: Node3D = %SfxWheel

func _ready() -> void:
	master_knob = %Master
	music_knob = %Music
	sfx_knob = %SFX
	
	master_value = SettingsHandler.get_master()
	music_value = SettingsHandler.get_music()
	sfx_value = SettingsHandler.get_sfx()
	
	
	master_knob.value = master_value
	music_knob.value = music_value
	sfx_knob.value = sfx_value

func _process(_delta: float) -> void:
	
	master_value = master_knob.value
	music_value = music_knob.value
	sfx_value = sfx_knob.value
	
	print(music_value)
	
	SettingsHandler.set_master(master_value)
	SettingsHandler.set_music(music_value)
	SettingsHandler.set_sfx(sfx_value)
	
	SettingsHandler.save()
	
	AudioServer.set_bus_volume_db(master_bus_index, master_value)
	AudioServer.set_bus_volume_db(music_bus_index, music_value)
	AudioServer.set_bus_volume_db(sfx_bus_index, sfx_value)
	
	master_wheel.rotation.z = -master_knob.rotation *.6
	music_wheel.rotation.z = -music_knob.rotation *.6
	sfx_wheel.rotation.z = -sfx_knob.rotation *.6
	
	if master_value < -9.5:
		AudioServer.set_bus_mute(master_bus_index, true)
	else:
		AudioServer.set_bus_mute(master_bus_index, false)

	if music_value < -9.5:
		AudioServer.set_bus_mute(music_bus_index, true)
	else:
		AudioServer.set_bus_mute(music_bus_index, false)

	if sfx_value < -9.5:
		AudioServer.set_bus_mute(sfx_bus_index, true)
	else:
		AudioServer.set_bus_mute(sfx_bus_index, false)
		
