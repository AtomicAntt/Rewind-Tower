extends Node3D
class_name MoveWithTable

@onready var area3d: Area3D = %Area3D

@onready var table = get_tree().get_first_node_in_group("Table")

@onready var table_adjuster: TableAdjuster = get_tree().get_first_node_in_group("TableAdjuster")

var bodies_in_area = []

var table_in_range: bool = false

@onready var move_with_table: Node3D = get_tree().get_first_node_in_group("MoveWithTable")

## Used to calculate our delta position of the table when moving troops relative to the table adjuster.
@onready var prev_position: Vector3

func _physics_process(_delta: float) -> void:
	var delta_position: Vector3 = table_adjuster.reported_global_position - prev_position
	prev_position = table_adjuster.reported_global_position
	
	if table_adjuster.is_picked_up():
		# Check for any rigidbodies
		for body: Node3D in area3d.get_overlapping_bodies():
			if body is RigidBody3D:
				var rigid_body_3d: RigidBody3D = body
				rigid_body_3d.global_position += delta_position
		
		# Check for specifically defensive projectiles
		for area in area3d.get_overlapping_areas():
			if area is DefenseProjectile:
				print("defense projectile detected")
				var defense_projectile: DefenseProjectile = area
				defense_projectile.global_position += delta_position
	
	#if table_adjuster.is_picked_up():
		#for body in area.get_overlapping_bodies():
			#if body is RigidBody3D and body is DefenseTroop or body is BearTrap:
				#var pickable = body as XRToolsPickable
				#if !pickable.is_picked_up():
					#body.reparent(move_with_table)
					#bodies_in_area.append(body)
					#pickable.freeze = true
					#pickable.enabled = false
#
				#
	#else:
		#for body in bodies_in_area:
			#body.reparent(get_tree().get_first_node_in_group("GameManager"))
			#bodies_in_area.erase(body)
			#if body is XRToolsPickable:
				#var pickable = body as XRToolsPickable
				#pickable.freeze = false
				#pickable.enabled = true
