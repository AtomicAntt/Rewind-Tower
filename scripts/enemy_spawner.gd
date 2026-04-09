class_name EnemySpawner
extends Timer

const enemy: PackedScene = preload("res://scenes/enemies/Enemy.tscn")
const raider: PackedScene = preload("res://scenes/enemies/Raider.tscn")
const wolf: PackedScene = preload("res://scenes/enemies/Wolf.tscn")
const knight: PackedScene = preload("res://scenes/enemies/Knight.tscn")
const bear: PackedScene = preload("res://scenes/enemies/Bear.tscn")

@export var path_3d: Path3D

func _ready() -> void:
	# Whenever a new round starts, this timer will reset and start again.
	RoundManager.round_started.connect(start)
	RoundManager.round_started.connect(change_wait_time)
	# Stop in intermission.
	RoundManager.intermission_started.connect(stop)
	# Also stop if it's game over.
	RoundManager.game_over.connect(stop)
	
func _on_timeout() -> void:
	if RoundManager.in_battle() and not RoundManager.current_queue.is_empty():
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
		"Knight":
			enemy_instance = knight.instantiate()
		"Bear":
			enemy_instance = bear.instantiate()
		"":
			pass
		_:
			print(enemy_name + " is not found.")
	
	if is_instance_valid(enemy_instance):
		path_3d.add_child(enemy_instance)

func change_wait_time() -> void:
	wait_time = RoundManager.current_wait_time
