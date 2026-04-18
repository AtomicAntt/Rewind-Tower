@tool
class_name Swordsman
extends DefenseTroop

@onready var shoot_raycast: RayCast3D = %ShootRaycast

func _on_shoot_timer_timeout() -> void:
	if Engine.is_editor_hint():
		return
	
	if is_instance_valid(closest_enemy_area) and can_shoot and get_enemy_distance(closest_enemy_area) <= attack_range:
		animator._animate()
		shoot_raycast._hit()
		%SwordHit.play()
		
		lose_power()
