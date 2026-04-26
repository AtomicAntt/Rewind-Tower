extends Node

var objects_to_move = []

var table

var table_pos: float = 0.0
var table_prev_pos: float = 0.0

func _ready() -> void:
	table = get_tree().get_first_node_in_group("Table")
	for object in get_tree().get_nodes_in_group("MoveWithTable"):
		objects_to_move.append(object)

func _process(delta: float) -> void:
	table_pos = table.global_position.y
	for object in objects_to_move:
		object.global_position.y += table_pos-table_prev_pos
	table_prev_pos = table_pos
