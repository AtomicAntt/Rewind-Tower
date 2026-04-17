extends Node
class_name KnobInteractable

@export var pickable: XRToolsPickable
var controller: XRController3D

var position: Vector3
var rotation: float

var controller_rot: float
var prev_controller_rot: float = 0.0

var picked_up_rotation: float

var value: float = 0.0

var has_been_picked_up: bool = false
var has_been_let_go: bool = false

var prev_rotation: float = 0

var delta_rot: float

func _ready() -> void:
	position = pickable.position
	rotation = 0

func _process(_delta: float) -> void:
	pickable.position = position
	pickable.rotation = Vector3(0,0,rotation)
	
	
	if pickable.is_picked_up():
		has_been_let_go = false
		
		controller = pickable.get_picked_up_by_controller()
		
		controller_rot = controller.rotation.z
		
		var controller_rot_diff = controller_rot - prev_controller_rot
		
		#Fix Wraparound
		if controller_rot_diff > PI:
			controller_rot -= TAU
		elif controller_rot_diff < -PI:
			controller_rot += TAU
		
		prev_controller_rot = controller_rot
		
		#Called once per pickup
		if not has_been_picked_up:
			_on_picked_up()
			has_been_picked_up = true
		
		delta_rot = controller_rot - picked_up_rotation
		
		delta_rot = clampf(delta_rot, -1, 3.8)
		
		rotation = delta_rot
		
		value = -delta_rot
		
		
		if value > 0:
			value *= 6
		else:
			value *= 2.75
		
	else:
		has_been_picked_up = false
		
		#Called once per let go
		if not has_been_let_go:
			prev_rotation += (delta_rot - prev_rotation)
			has_been_let_go = true
		
func _on_picked_up() -> void:
	picked_up_rotation = controller_rot - prev_rotation
