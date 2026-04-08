extends Node3D

@onready var interactable_handle: XRToolsInteractableHandle = %InteractableHandle
@onready var relative_area_3d: Area3D = %RelativeArea3D
@onready var static_body_3d: StaticBody3D = %StaticBody3D

@onready var prev_position: Vector3 = global_position

func _physics_process(_delta: float) -> void:
	var delta_position: Vector3 = static_body_3d.global_position - prev_position
	
	prev_position = static_body_3d.global_position
	
	if interactable_handle.is_picked_up():
		for body in relative_area_3d.get_overlapping_bodies():
			if body is RigidBody3D:
				var rigid_body_3d: RigidBody3D = body
				rigid_body_3d.global_position += delta_position
