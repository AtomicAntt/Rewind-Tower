class_name EnemySpawner
extends Timer

@onready var enemy: PackedScene = preload("res://scenes/Enemy.tscn")
@onready var raider: PackedScene = preload("res://scenes/Raider.tscn")
@onready var wolf: PackedScene = preload("res://scenes/Wolf.tscn")

@export var path_3d: Path3D

func _on_timeout() -> void:
	if not RoundManager.in_intermission() and not RoundManager.current_queue.is_empty():
		spawn_enemy(RoundManager.current_queue.pop_front())

func spawn_enemy(enemy_name: String) -> void:
	var enemy_instance: Enemy
	
	match enemy_name:
		"Enemy":
			enemy_instance = enemy.instantiate()
		"Raider":
			enemy_instance = raider.instantiate()
		"Wolf":
			enemy_instance = wolf.instantiate()
		_:
			print(enemy_name + " is not found.")
	
	if is_instance_valid(enemy_instance):
		path_3d.add_child(enemy_instance)
