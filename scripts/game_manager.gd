extends Node

var archer_troop_scene: PackedScene = preload("res://scenes/Archer.tscn")
var swordsman_troop_scene: PackedScene = preload("res://scenes/Swordsman.tscn")
var beartrap_scene: PackedScene = preload("res://scenes/BearTrap.tscn")

@export var drawer_spawn_point: Node3D

func _respawn_troop(type: String):
	if type == "Archer":
		var new_archer = archer_troop_scene.instantiate()
		add_child(new_archer)
		new_archer.global_position = drawer_spawn_point.global_position
	elif type == "Swordsman":
		var new_swordsman = swordsman_troop_scene.instantiate()
		add_child(new_swordsman)
		new_swordsman.global_position = drawer_spawn_point.global_position
	elif type == "BearTrap":
		var new_beartrap = beartrap_scene.instantiate()
		add_child(new_beartrap)
		new_beartrap.global_position = drawer_spawn_point.global_position
