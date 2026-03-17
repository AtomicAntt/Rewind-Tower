class_name Enemy
extends PathFollow3D

## Enemy must be a child of a PathFollow3D, which must be a child of a Path3D
@onready var path_3d: Path3D = get_parent()

@onready var path_length: float = path_3d.curve.get_baked_length()

## Amount of HP the enemy has.
@export var enemy_hp: float = 10.0

@onready var max_enemy_hp: float = enemy_hp

## Enemy's speed: how many meters they move per second.
@export var enemy_speed: float = 0.1

func _physics_process(delta: float) -> void:
	var new_progress_ratio: float = progress_ratio
	new_progress_ratio += (enemy_speed * delta) / path_length
	
	if new_progress_ratio >= 1.0:
		queue_free()
	else:
		progress_ratio = new_progress_ratio

func hurt(amount: float) -> void:
	enemy_hp -= amount
	if enemy_hp <= 0:
		queue_free()
