@tool
class_name DefenseTroop
extends XRToolsPickable

var troop_holder: Node3D

var power: int = 0

## The attack range of this defense troop, which is how close the enemy must be to be able to target them.
@export var attack_range: float = 100.0

## The attack damage of this defense troop. If there are projectiles, it should have their damage set by this value automatically.
@export var attack_damage: float = 2.0

## The max power which this troop can have.
@export var max_power: int = 0

## The amount of power this troop loses whenever they use their attack/ability.
@export var power_lose_rate: int = 0

## The ProgressBar control node that is used to display power value.
@export var power_bar: ProgressBar

## The crank attached to this defense troop.
@export var crank: Crank

## Whether or not this defense troop needs to look at enemies.
@export var looks_at_enemy: bool = true

## The object that gets rotated towards the enemy when it looks at them.
@export var body: Node3D

## Offset for looking at the enemies on the body
@export var look_offset: int

## Whether this troop can use their attack/ability.
## Not true if players pick this up, or if it does not have sufficient power.
var can_shoot: bool = false

var closest_enemy_area: Area3D = null

## References the AnimationPlayer.
@export var animator: AnimationPlayer

## A duplicate model with stencil buffer x-ray material so you can see this troop through walls.
@export var xray: Node3D

@onready var initial_body_orientation: Vector3 = body.rotation

func _ready():
	super._ready()
	power_bar.max_value = max_power
	
	# For tutorial
	grabbed.connect(emit_grab_troop)
	dropped.connect(emit_drop_troop)
	
	troop_holder = get_tree().get_first_node_in_group("TroopHolder")

func emit_grab_troop(_pickable, _by) -> void:
	TutorialSystem.emit_signal("complete", "GrabTroop")
	
	#if (troop_holder.is_ancestor_of(self) == false):
		#self.reparent(troop_holder)

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
		
	if looks_at_enemy:
		closest_enemy_area = find_closest_enemy_area3d()
		if is_instance_valid(closest_enemy_area) and can_shoot and get_enemy_distance(closest_enemy_area) <= attack_range:
			body.look_at(find_closest_enemy_area3d().global_position, Vector3.UP, true)
			body.rotation.x = 0
			body.rotate_y(look_offset)
			body.rotation.z = 0
	
	# For tutorial
	if power >= max_power:
		TutorialSystem.emit_signal("complete", "RewindTroop")

## Find the closest enemy hitbox it can find that is alive. If none is found, it returns null.
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

## Gets the enemy distance given an enemy area (hitbox)
func get_enemy_distance(enemy_area: Area3D) -> float:
	if is_instance_valid(enemy_area):
		return global_position.distance_to(enemy_area.global_position)
	else:
		return INF 

## This method decreases the power of this defense troop by the power_lose_rate.
func lose_power() -> void:
	crank.power -= power_lose_rate
	power -= power_lose_rate
	crank.crank_value = (crank.crank_value/abs(crank.crank_value)) * crank.power

## Shows the stencil buffer xray
func show_xray() -> void:
	xray.visible = true

## Hides the stencil buffer xray
func hide_xray() -> void:
	xray.visible = false
