@tool
class_name DefenseTroop
extends XRToolsPickable

@onready var projectile: PackedScene = preload("res://scenes/DefenseProjectile.tscn")
#Used for archer
var shoot_position: Marker3D
#Used for swordsman
var shoot_raycast: RayCast3D

var power: int = 0

@export var attack_range: float = 100.0
@export var attack_damage: float = 2.0

enum troop_types {ARCHER, SWORDSMAN, BEARTRAP}

@export var troop_type: troop_types
var melee: bool

@export var max_power: int = 0
@export var power_lose_rate: int = 0

@export var power_bar: ProgressBar
@export var crank: Crank

#The object that gets rotated towards the enemy
@export var body: Node3D

#Offset for looking at the enemies
@export var look_offset: int

var can_shoot: bool = false

var closest_enemy_area: Area3D = null

#Reference the AnimationPlayer which should have the defense_animator script on it
@export var animator: AnimationPlayer

@export var xray: Node3D

@onready var initial_body_orientation: Vector3 = body.rotation

func _ready():
	super._ready()
	power_bar.max_value = max_power
	
	if troop_type == troop_types.ARCHER:
		melee = false
	elif troop_type == troop_types.SWORDSMAN:
		melee = true
	
	if melee:
		shoot_raycast = %ShootRaycast
		shoot_raycast.swordsman = self
	else:
		shoot_position = %ShootPosition
	
	# For tutorial
	grabbed.connect(emit_grab_troop)
	dropped.connect(emit_drop_troop)

## This is for tutorial purposes only
func emit_grab_troop(_pickable, _by) -> void:
	TutorialSystem.emit_signal("complete", "GrabTroop")

## This is for tutorial purposes only
func emit_drop_troop(_pickable) -> void:
	TutorialSystem.emit_signal("complete", "DropTroop")

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if is_picked_up():
		crank.pickable.enabled = true
		body.rotation = initial_body_orientation
	else:
		crank.pickable.enabled = false
	
	power = crank.power
	
	crank.crank_value = clamp(crank.crank_value, -max_power, max_power ) 
	power = clamp(power, 0, max_power)
	crank.power = clamp(crank.power, 0, max_power)
	
	power_bar.value = power
	
	if power >= power_lose_rate and not is_picked_up():
		can_shoot = true
	else:
		can_shoot = false
	
	if not Engine.is_editor_hint():
		closest_enemy_area = find_closest_enemy_area3d()
		if is_instance_valid(closest_enemy_area) and can_shoot and get_enemy_distance(closest_enemy_area) <= attack_range:
			body.look_at(find_closest_enemy_area3d().global_position, Vector3.UP, true)
			body.rotation.x = 0
			body.rotate_y(look_offset)
			body.rotation.z = 0
		
		# For tutorial
		if power >= max_power:
			TutorialSystem.emit_signal("complete", "RewindTroop")

func find_closest_enemy_area3d() -> Area3D:
	var closest_area3d: Area3D = null
	var closest_distance: float = INF
	for enemy_area: Area3D in get_tree().get_nodes_in_group("EnemyHitbox"):
		if global_position.distance_to(enemy_area.global_position) < closest_distance and can_shoot:
			var enemy_node: Enemy = enemy_area.get_parent()
			if not enemy_node.is_dead:
				closest_area3d = enemy_area
				closest_distance = global_position.distance_to(enemy_area.global_position)
	return closest_area3d

func get_enemy_distance(enemy_area: Area3D) -> float:
	if is_instance_valid(enemy_area):
		return global_position.distance_to(enemy_area.global_position)
	else:
		return INF 

func _on_shoot_timer_timeout() -> void:
	if is_instance_valid(closest_enemy_area) and not Engine.is_editor_hint() and can_shoot and !melee and get_enemy_distance(closest_enemy_area) <= attack_range:
		var projectile_instance: DefenseProjectile = projectile.instantiate()
		get_parent().add_child(projectile_instance)
		projectile_instance.global_position = shoot_position.global_position
		projectile_instance.look_at(closest_enemy_area.global_position)
		projectile_instance.set_damage(attack_damage)
		projectile_instance.set_defense_troop(self)
		
		animator._animate()
		
		crank.power -= power_lose_rate
		power -= power_lose_rate
		crank.crank_value = (crank.crank_value/abs(crank.crank_value)) * crank.power
	elif is_instance_valid(closest_enemy_area) and not Engine.is_editor_hint() and can_shoot and melee and get_enemy_distance(closest_enemy_area) <= attack_range:
		animator._animate()
		shoot_raycast._hit()
		%SwordHit.play()
		
		crank.power -= power_lose_rate
		power -= power_lose_rate
		crank.crank_value = (crank.crank_value/abs(crank.crank_value)) * crank.power

func _play_arrow_hit():
	%ArrowHit.play()

func show_xray() -> void:
	xray.visible = true

func hide_xray() -> void:
	xray.visible = false
