@tool
class_name DefenseTroop
extends XRToolsPickable

@onready var projectile: PackedScene = preload("res://scenes/DefenseProjectile.tscn")
@onready var shoot_position: Marker3D = $ShootPosition

var power: int = 0
var power_lost: int = 0;

@export var max_power: int = 0
@export var power_lose_rate: int = 0

@export var power_bar: ProgressBar
@export var crank: Node3D

@export var pickable: XRToolsPickable

#The object that gets rotated towards the enemy
@export var body: Node3D

#Offset for looking at the enemies
@export var look_offset: int

var can_shoot: bool = false

var closest_enemy_area: Area3D = null

#Reference the AnimationPlayer which should have the defense_animator script on it
@export var animator: AnimationPlayer

func _ready():
	power_bar.max_value = max_power

func _physics_process(_delta: float) -> void:
	
	power = crank.power
	power -= power_lost
	
	clamp(power, 0, max_power)
	
	power_bar.value = power
	
	if power >= power_lose_rate and not pickable.is_picked_up():
		can_shoot = true
	else:
		can_shoot = false
	
	if not Engine.is_editor_hint():
		closest_enemy_area = find_closest_enemy_area3d()
		if is_instance_valid(closest_enemy_area):
			body.look_at(find_closest_enemy_area3d().global_position, Vector3.UP, true)
			body.rotation.x = 0
			body.rotate_y(look_offset)
			body.rotation.z = 0

func find_closest_enemy_area3d() -> Area3D:
	var closest_area3d: Area3D = null
	var closest_distance: float = INF
	for enemy_area: Area3D in get_tree().get_nodes_in_group("EnemyHitbox"):
		if global_position.distance_to(enemy_area.global_position) < closest_distance and can_shoot:
			closest_area3d = enemy_area
			closest_distance = global_position.distance_to(enemy_area.global_position)
	return closest_area3d

func _on_shoot_timer_timeout() -> void:
	if is_instance_valid(closest_enemy_area) and not Engine.is_editor_hint() and can_shoot:
		var projectile_instance: DefenseProjectile = projectile.instantiate()
		get_parent().add_child(projectile_instance)
		projectile_instance.global_position = shoot_position.global_position
		projectile_instance.look_at(closest_enemy_area.global_position)
		
		animator._animate()
		
		power_lost += 1 * power_lose_rate
