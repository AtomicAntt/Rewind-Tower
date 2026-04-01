class_name DefenseProjectile
extends Area3D

## Amount of damage this projectile deals.
@export var damage: float = 0.0

## How fast this projectile moves in m/s
@export var speed: float = 2.0

var defense_troop: DefenseTroop

## Sets the damage of this projectile.
func set_damage(amount: float) -> void:
	damage = amount

## Sets the defense troop that shot this defense projectile.
func set_defense_troop(new_defense_troop: DefenseTroop) -> void:
	defense_troop = new_defense_troop

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("EnemyHitbox"):
		# Area in group Enemy should just be the hitbox of the enemy.
		var enemy: Enemy = area.get_parent()
		enemy.hurt(damage)
		if is_instance_valid(defense_troop):
			defense_troop._play_arrow_hit()
		queue_free()

func _physics_process(delta: float) -> void:
	var forward = -global_transform.basis.z
	position += forward * speed * delta

func _on_destruction_timer_timeout() -> void:
	queue_free()
