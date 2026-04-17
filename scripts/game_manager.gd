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

func _respawn_troop(type: DefenseTroop.troop_types):
	if type == DefenseTroop.troop_types.ARCHER:
		var new_archer = archer_troop_scene.instantiate()
		add_child(new_archer)
		new_archer.global_position = drawer_spawn_point.global_position
	elif type == DefenseTroop.troop_types.SWORDSMAN:
		var new_swordsman = swordsman_troop_scene.instantiate()
		add_child(new_swordsman)
		new_swordsman.global_position = drawer_spawn_point.global_position
	elif type == DefenseTroop.troop_types.BEARTRAP:
		var new_beartrap = beartrap_scene.instantiate()
		add_child(new_beartrap)
		new_beartrap.global_position = drawer_spawn_point.global_position
	
func _pause_game():
	game_paused = true
	
	var turn_settings_instance = turn_settings.instantiate()
	var sound_settings_instance = sound_settings.instantiate()
	
	%TurnSettingsSpawn.add_child(turn_settings_instance)
	%SoundSettingsSpawn.add_child(sound_settings_instance)
	
	get_tree().call_group("Pauseable", "set_process", false)
	get_tree().call_group("Pauseable", "set_physics_process", false)
	
func _unpause_game():
	game_paused = false
	get_tree().call_group("Pauseable", "set_process", true)
	get_tree().call_group("Pauseable", "set_physics_process", true)
	
	for child in %TurnSettingsSpawn.get_children():
		child.queue_free()
	for child in %SoundSettingsSpawn.get_children():
		child.queue_free()
