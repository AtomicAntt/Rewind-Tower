@tool
class_name TwisterInteractable
extends XRToolsInteractableHandleDriven

@export var pickable: XRToolsPickable
@export var mesh: MeshInstance3D

var twister_value: float = 0.0
var previous_twister_value: float = 0.0

var value: float = 0.0
var value_threshold: float = 2.0

var prev_rotation: float = 0.0

# Emitted whenever this interactable has been turned by a value of 20.0
signal turned(controller: XRController3D)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	pickable.global_position = global_position

func _physics_process(_delta) -> void:
	if Engine.is_editor_hint():
		return
	
	# basically crank but z
	pickable.global_position = global_position
	pickable.rotation = Vector3(0, 0, pickable.rotation.z)
	mesh.rotation = pickable.rotation
	
	if pickable.is_picked_up():
		var controller: XRController3D = pickable.get_picked_up_by_controller()
		
		var current_rotation = controller.rotation.z
		var delta_rot = current_rotation - prev_rotation
		
		 #Fix wraparound
		if delta_rot > PI:
			delta_rot -= TAU
		elif delta_rot < -PI:
			delta_rot += TAU
		
		twister_value += delta_rot
		pickable.rotation.z += delta_rot
		mesh.rotation = pickable.rotation
		value = abs(twister_value)
		prev_rotation = current_rotation
		
		var int1: int = previous_twister_value
		var int2: int = twister_value
		if int1 != int2 and is_instance_valid(%XRToolsRumbler):
				previous_twister_value = twister_value
				%XRToolsRumbler.rumble_hand(controller)
				%KnobTurn.play()
	
		if value >= value_threshold:
			emit_signal("turned", controller)
			value = 0
			twister_value = 0

func _on_twister_pickable_grabbed(_pickable: Variant, by: Variant) -> void:
	if XRHelpers.get_xr_controller(by):
		var controller: XRController3D = XRHelpers.get_xr_controller(by)
		prev_rotation = controller.rotation.z
