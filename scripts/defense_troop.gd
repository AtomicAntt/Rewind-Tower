@tool
class_name DefenseTroop
extends XRToolsPickable

@onready var projectile: PackedScene = preload("res://scenes/DefenseProjectile.tscn")
#Used for archer
var shoot_position: Marker3D
#Used for swordsman
var shoot_raycast: RayCast3D

var game_manager: Node3D

var power: int = 0
var power_lost: int = 0;

@export var attack_range: float = 100.0
@export var attack_damage: float = 2.0

@export var troop_type: String

@export var melee: bool

@export var max_power: int = 0
@export var power_lose_rate: int = 0

@export var power_bar: ProgressBar
@export var crank: Crank

@export var pickable: XRToolsPickable

#The object that gets rotated towards the enemy
@export var body: Node3D

#Offset for looking at the enemies
@export var look_offset: int

var can_shoot: bool = false

var closest_enemy_area: Area3D = null

#Reference the AnimationPlayer which should have the defense_animator script on it
@export var animator: AnimationPlayer

@export var xray: Node3D

var enemy_distance: float

func _ready():
	super._ready()
	power_bar.max_value = max_power
	
	game_manager = get_parent_node_3d()
	
	if melee:
		shoot_raycast = $SM_swordsman/SM_swordsmanBase/SM_swordsmanBody/ShootRaycast
		shoot_raycast.swordsman = self
	else:
		shoot_position = $SM_archer/SM_archerBase/SM_archerBody/ShootPosition
		
	enemy_distance = attack_range + 1
	
	# For tutorial
	grabbed.connect(emit_grab_troop)

## This is for tutorial purposes only
func emit_grab_troop(_pickable, _by) -> void:
	TutorialSystem.emit_signal("complete", "GrabTroop")

func _physics_process(_delta: float) -> void:
	if is_instance_valid(closest_enemy_area):
		enemy_distance = global_position.distance_to(closest_enemy_area.global_position)
	
	if is_picked_up():
		crank.pickable.enabled = true
	else:
		crank.pickable.enabled = false
	
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
		if is_instance_valid(closest_enemy_area) and can_shoot and enemy_distance <= attack_range:
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

func _on_shoot_timer_timeout() -> void:
	if is_instance_valid(closest_enemy_area) and not Engine.is_editor_hint() and can_shoot and !melee and enemy_distance <= attack_range:
		var projectile_instance: DefenseProjectile = projectile.instantiate()
		get_parent().add_child(projectile_instance)
		projectile_instance.global_position = shoot_position.global_position
		projectile_instance.look_at(closest_enemy_area.global_position)
		projectile_instance.archer = self
		
		animator._animate()
		
		power_lost += 1 * power_lose_rate
	elif is_instance_valid(closest_enemy_area) and not Engine.is_editor_hint() and can_shoot and melee and enemy_distance <= attack_range:
		animator._animate()
		shoot_raycast._hit()
		power_lost += 1 * power_lose_rate


func on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Drawer"):
		xray.visible = true
		
	if area.is_in_group("Boundary"):
		game_manager._respawn_troop(troop_type)
		queue_free()


func on_area_exited(area: Area3D) -> void:
	if area.is_in_group("Drawer"):
		xray.visible = false
