@tool
class_name Catapult
extends DefenseTroop

@export var anim_catapult_launch: String
@export var anim_frame_launch: String
@export var anim_rock_launch: String

@onready var shoot_position: Marker3D = %ShootPosition

@onready var catapult_projectile: PackedScene = preload("res://scenes/CatapultProjectile.tscn")

var gravity_value: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _on_shoot_timer_timeout() -> void:
	# Do not shoot if inside the editor.
	if Engine.is_editor_hint():
		return
		
	if is_instance_valid(closest_enemy_area) and can_shoot and get_enemy_distance(closest_enemy_area) <= attack_range:
		play_shoot_animation()
		lose_power()

## This will lead to firing a projectile as well, since anim_rock_launch will call fire_projectile()
func play_shoot_animation() -> void:
	animator.queue(anim_catapult_launch)
	animator.queue(anim_rock_launch)
	if is_instance_valid(closest_enemy_area):
		var enemy_target: Enemy = closest_enemy_area.get_parent()
		fire_projectile(enemy_target.global_position)
	animator.queue(anim_frame_launch)

## This should get called at the start of anim_rock_launch to have a synced animation
func fire_projectile(global_enemy_position: Vector3) -> void:
	# First, lets calculate the time it would take for the projectile to hit the floor (Y AXIS)
	# We are using this formula: displacement_y = v_iy*t + 1/2*a_y*t^2
	# We know initial velocity (y) = 0 and a_y = gravity (acceleration)
	# t = sqrt(2*displacement/a)
	var y_displacement: float = shoot_position.global_position.y - global_enemy_position.y
	var time_to_enemy: float = sqrt((2 * y_displacement) / gravity_value)
	
	# Now, we figure out the initial velocity in the horizontal axis (Z & X)
	
	# First, we get the horizontal displacement
	var shooting_horizontal_position: Vector3 = Vector3(shoot_position.global_position.x, 0, shoot_position.global_position.z)
	var enemy_horizontal_position: Vector3 = Vector3(global_enemy_position.x, 0, global_enemy_position.z)
	var horizontal_displacement: float = shooting_horizontal_position.distance_to(enemy_horizontal_position)
	
	# We know that v_i = displacement/time_to_enemy
	var initial_horizontal_speed = horizontal_displacement / time_to_enemy
	
	# Now we can shoot the projectile
	var projectile_instance: CatapultProjectile = catapult_projectile.instantiate()
	get_parent().add_child(projectile_instance)
	projectile_instance.global_position = shoot_position.global_position
	projectile_instance.look_at(closest_enemy_area.global_position, Vector3.UP, true)
	projectile_instance.rotation.z = 0
	projectile_instance.rotation.x = 0
	projectile_instance.set_damage(attack_damage)
	projectile_instance.set_stream(%ArrowHit.stream)
	projectile_instance.set_forward_speed(initial_horizontal_speed)


#func _on_animation_player_animation_changed(_old_name: StringName, new_name: StringName) -> void:
	#if new_name == anim_rock_launch:
		#if is_instance_valid(closest_enemy_area):
			#var enemy_target: Enemy = closest_enemy_area.get_parent()
			#fire_projectile(enemy_target.global_position)
