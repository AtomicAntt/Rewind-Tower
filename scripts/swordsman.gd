@tool
class_name Swordsman
extends DefenseTroop

@onready var shoot_raycast: RayCast3D = %ShootRaycast
@export var animation_attack: String

func _on_shoot_timer_timeout() -> void:
	# Do not shoot if inside the editor.
	if Engine.is_editor_hint():
		return
	
	if is_instance_valid(closest_enemy_area) and can_shoot and get_enemy_distance(closest_enemy_area) <= attack_range:
		animate()
		shoot_raycast._hit()
		%SwordHit.play()
		
		lose_power()

func animate() -> void:
	animator.speed_scale = 2
	
	animator.queue(animation_attack)
