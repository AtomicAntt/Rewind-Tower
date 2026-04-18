class_name DefenseProjectile
extends Area3D

## Amount of damage this projectile deals.
@export var damage: float = 0.0

## How fast this projectile moves in m/s
@export var speed: float = 2.0

## AudioStream that will play on the Enemy when this projectile hits an enemy.
var audio_stream: AudioStream

## Sets the damage of this projectile.
func set_damage(amount: float) -> void:
	damage = amount

## Sets the AudioStream that will play on the Enemy when hitting them.
func set_stream(new_stream: AudioStream) -> void:
	audio_stream = new_stream

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("EnemyHitbox"):
		# Area in group Enemy should just be the hitbox of the enemy.
		var enemy: Enemy = area.get_parent()
		enemy.hurt(damage)
		if audio_stream:
			enemy.play_hit_sound(audio_stream)
		queue_free()

func _physics_process(delta: float) -> void:
	var forward = -global_transform.basis.z
	position += forward * speed * delta

func _on_destruction_timer_timeout() -> void:
	queue_free()
