extends Timer

@onready var enemy: PackedScene = preload("res://scenes/Enemy.tscn")
@export var path_3d: Path3D

func _on_timeout() -> void:
	var enemy_instance: Enemy = enemy.instantiate()
	path_3d.add_child(enemy_instance)
