extends Node
class_name GameManager

const archer_troop_scene: PackedScene = preload("res://scenes/troops/Archer.tscn")
const swordsman_troop_scene: PackedScene = preload("res://scenes/troops/Swordsman.tscn")
const beartrap_scene: PackedScene = preload("res://scenes/troops/BearTrap.tscn")

const sound_settings: PackedScene = preload("res://scenes/SoundSettings.tscn")
const turn_settings: PackedScene = preload("res://scenes/TurnSettings.tscn")

@export var drawer_spawn_point: Node3D

var game_paused: bool = false

func _ready() -> void:
	AudioServer.set_bus_volume_db(0, SettingsHandler.get_master())
	AudioServer.set_bus_volume_db(1, SettingsHandler.get_music())
	AudioServer.set_bus_volume_db(2, SettingsHandler.get_sfx())
	
	var master_value = SettingsHandler.get_master()
	var music_value = SettingsHandler.get_music()
	var sfx_value = SettingsHandler.get_sfx()
	
	for child in get_tree().get_nodes_in_group("Dont Pause"):
		child.process_mode = Node.PROCESS_MODE_ALWAYS
	
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

func _pause_game():
	game_paused = true
	
	var turn_settings_instance = turn_settings.instantiate()
	var sound_settings_instance = sound_settings.instantiate()
	
	%TurnSettingsSpawn.add_child(turn_settings_instance)
	%SoundSettingsSpawn.add_child(sound_settings_instance)
	
	for node: Node in get_children():
		if node.process_mode != ProcessMode.PROCESS_MODE_ALWAYS:
			node.process_mode = Node.PROCESS_MODE_DISABLED

func _unpause_game():
	game_paused = false
	
	for node: Node in get_children():
		if node.process_mode != ProcessMode.PROCESS_MODE_ALWAYS:
			node.process_mode = Node.PROCESS_MODE_INHERIT

	
	for child in %TurnSettingsSpawn.get_children():
		child.queue_free()
	for child in %SoundSettingsSpawn.get_children():
		child.queue_free()
