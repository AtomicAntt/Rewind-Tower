extends Node

@export var raycast: RayCast3D

var damage: float = 0.0

var swordsman: Node3D

func _process(_delta: float) -> void:
	if damage == 0.0 && swordsman != null:
		damage = swordsman.attack_damage

func _hit():
	if raycast.is_colliding():
		var area = raycast.get_collider()
		if area.is_in_group("EnemyHitbox"):
			var enemy: Enemy = area.get_parent()
			enemy.hurt(damage)
