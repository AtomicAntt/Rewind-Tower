extends Node
class_name KnobInteractable

@onready var pickable: XRToolsPickable = %Pickable
var controller: XRController3D

var position: Vector3
var rotation: float

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
		
		#Called once per pickup
		if not has_been_picked_up:
			_on_picked_up()
			has_been_picked_up = true
		
		delta_rot = controller.rotation.z - picked_up_rotation
		
		#Fix wraparound
		if delta_rot > 180:
			delta_rot -= 360
		elif delta_rot < -180:
			delta_rot += 360
		
		delta_rot = clampf(delta_rot, -10, 10)
		
		rotation = delta_rot
		
		value = -delta_rot
		
		print(delta_rot)
		
	else:
		has_been_picked_up = false
		
		#Called once per let go
		if not has_been_let_go:
			prev_rotation += (delta_rot - prev_rotation)
			#print(prev_rotation)
			has_been_let_go = true
		
func _on_picked_up() -> void:
	picked_up_rotation = controller.rotation.z - prev_rotation
