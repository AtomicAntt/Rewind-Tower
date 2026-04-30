extends Node3D
class_name MoveWithTable

@onready var area: Area3D = %Area3D

@onready var table = get_tree().get_first_node_in_group("Table")

@onready var table_adjuster: TableAdjuster = get_tree().get_first_node_in_group("TableAdjuster")

var bodies_in_area = []

var table_in_range: bool = false

var table_pos: float = 0.0 
var table_prev_pos: float = 0.0

func _process(_delta: float) -> void:
	if table_adjuster.is_picked_up():
		for body in area.get_overlapping_bodies():
			if body is RigidBody3D and body is DefenseTroop:
				var pickable = body as XRToolsPickable
				if !pickable.is_picked_up():
					body.reparent(table)
					bodies_in_area.append(body)
					pickable.freeze = true
					pickable.enabled = false
	else:
		for body in bodies_in_area:
			body.reparent(get_tree().get_first_node_in_group("GameManager"))
			bodies_in_area.erase(body)
			var pickable = body as XRToolsPickable
			pickable.freeze = false
			pickable.enabled = true
