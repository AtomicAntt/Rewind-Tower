class_name Boundary
extends Node3D

@onready var game_manager: GameManager = get_tree().get_first_node_in_group("GameManager")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is XRToolsPickable:
		var pickable: XRToolsPickable = body
		pickable.linear_velocity = Vector3.ZERO
		pickable.angular_velocity = Vector3.ZERO
		pickable.global_transform = game_manager.drawer_spawn_point.global_transform
