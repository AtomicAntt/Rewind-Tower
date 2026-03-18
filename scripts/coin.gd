extends Node

var move_towards_hand: bool = false;

var hand: XRController3D

func _physics_process(_delta: float) -> void:
	if move_towards_hand:
		var distance = $RigidBody3D.global_position.distance_to(hand.position)
		
		var direction = (hand.position - $RigidBody3D.global_position).normalized()
		
		$RigidBody3D.apply_force(direction * 10)
		if distance < .05:
			queue_free()


func _on_object_in_range(area: Area3D) -> void:
	if area.get_parent_node_3d() is XRController3D:
		$RigidBody3D.gravity_scale = 0
		hand = area.get_parent_node_3d()
		move_towards_hand = true
