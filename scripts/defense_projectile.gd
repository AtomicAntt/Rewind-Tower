class_name DefenseProjectile
extends Area3D

## Amount of damage this projectile deals.
@export var damage: float = 0.0

## How fast this projectile moves in m/s
@export var speed: float = 2.0

var archer: Node3D


func _process(delta: float) -> void:
	if damage == 0.0 and archer != null:
		damage = archer.attack_damage

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("EnemyHitbox"):
		# Area in group Enemy should just be the hitbox of the enemy.
		var enemy: Enemy = area.get_parent()
		enemy.hurt(damage)
		queue_free()

func _physics_process(delta: float) -> void:
	var forward = -global_transform.basis.z
	position += forward * speed * delta
