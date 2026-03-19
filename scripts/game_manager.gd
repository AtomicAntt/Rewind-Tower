extends Node

var archer_troop_scene: PackedScene = preload("res://scenes/Archer.tscn")

@export var drawer_spawn_point: Node3D

func _ready() -> void:
	_respawn_troop()

func _respawn_troop():
	var new_archer = archer_troop_scene.instantiate()
	add_child(new_archer)
	new_archer.global_position = drawer_spawn_point.global_position
