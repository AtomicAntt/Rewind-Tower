@tool
class_name TutorialUITooltip3D
extends XRToolsViewport2DIn3D

@onready var xr_camera: XRCamera3D = get_tree().get_first_node_in_group("XRCamera3D")

func _physics_process(_delta: float) -> void:
	if is_instance_valid(xr_camera):
		look_at(xr_camera.global_position, Vector3.UP, true)
	else:
		xr_camera = get_tree().get_first_node_in_group("XRCamera3D")
