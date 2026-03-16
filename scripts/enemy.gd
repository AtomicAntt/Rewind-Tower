class_name Enemy
extends Area3D

## Enemy must be a child of a PathFollow3D, which must be a child of a Path3D
@onready var path_3d: Path3D = get_parent().get_parent()

## Enemy must be a child of a PathFollow3D
@onready var path_follow_3d: PathFollow3D = get_parent()

@onready var path_length: float = path_3d.curve.get_baked_length()

## Enemy's speed: how many meters they move per second.
@export var enemy_speed: float = 0.1

func _physics_process(delta: float) -> void:
	var new_progress_ratio: float = path_follow_3d.progress_ratio
	new_progress_ratio += (enemy_speed * delta) / path_length
	
	if new_progress_ratio >= 1.0:
		queue_free()
	else:
		path_follow_3d.progress_ratio = new_progress_ratio
