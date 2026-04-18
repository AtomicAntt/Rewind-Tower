class_name CatapultProjectile
extends DefenseProjectile

var gravity_value: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	position += velocity * delta

func set_forward_speed(new_speed: float) -> void:
	speed = new_speed
	velocity = global_transform.basis.z * speed

func apply_gravity(delta: float) -> void:
	velocity.y -= gravity * delta
