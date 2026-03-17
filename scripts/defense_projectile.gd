class_name DefenseProjectile
extends Area3D

## Amount of damage this projectile deals.
@export var damage: float = 2.0

## How fast this projectile moves in m/s
@export var speed: float = 2.0

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Enemy"):
		# Area in group Enemy should just be the hitbox of the enemy.
		var enemy: Enemy = area.get_parent()
		enemy.hurt(damage)
		queue_free()

func _physics_process(delta: float) -> void:
	var forward = -global_transform.basis.z
	position += forward * speed * delta
