extends Node

const archer_troop_scene: PackedScene = preload("res://scenes/Archer.tscn")
const swordsman_troop_scene: PackedScene = preload("res://scenes/Swordsman.tscn")
const beartrap_scene: PackedScene = preload("res://scenes/BearTrap.tscn")

@export var drawer_spawn_point: Node3D

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
