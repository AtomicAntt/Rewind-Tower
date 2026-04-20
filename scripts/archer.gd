@tool
class_name Archer
extends DefenseTroop

@onready var projectile: PackedScene = preload("res://scenes/DefenseProjectile.tscn")
@onready var shoot_position: Marker3D = %ShootPosition

@export var animation_attack: String
@export var animation_head: String

func _on_shoot_timer_timeout() -> void:
	# Do not shoot if inside the editor.
	if Engine.is_editor_hint():
		return
	
		print("pow")
	
	
	if is_instance_valid(closest_enemy_area) and can_shoot and get_enemy_distance(closest_enemy_area) <= attack_range:
		var projectile_instance: DefenseProjectile = projectile.instantiate()
		get_parent().add_child(projectile_instance)
		projectile_instance.global_position = shoot_position.global_position
		projectile_instance.look_at(closest_enemy_area.global_position)
		projectile_instance.set_damage(attack_damage)
		projectile_instance.set_stream(%ArrowHit.stream)
		
		animate()
		lose_power()
		print("pow")

func animate() -> void:
	animator.speed_scale = 2
	
	animator.queue(animation_attack)
	if animation_head != "":
		animator.queue(animation_head)
