class_name SnapCrank
extends Node

@export var pickable: XRToolsPickable

var crank_value: float = 0.0
var prev_rotation: float = 0.0

var previous_crank_value: float = 0.0

@export var power: float = 0.0

var position: Vector3

var turnmode: int

@export var min_rot: float = 0.05
@export var max_rot: float = -.75 

@export var min_value: float = 0
@export var max_value: float = 4 

func _ready() -> void:
	position = pickable.position

func _physics_process(_delta) -> void:
	pickable.position = position
	pickable.rotation = Vector3(0, pickable.rotation.y, 0)
	
	if pickable.is_picked_up():
		var controller: XRController3D = pickable.get_picked_up_by_controller()
		
		pickable.look_at(controller.global_position)
		
		pickable.rotation.x = 0
		pickable.rotation.z = 0
		
		var current_rotation = pickable.rotation.y
		var delta_rot = current_rotation - prev_rotation
		
		# Fix wraparound
		if delta_rot > PI:
			delta_rot -= TAU
		elif delta_rot < -PI:
			delta_rot += TAU
		
		
		@warning_ignore("narrowing_conversion")
		crank_value = remap(pickable.rotation.y, min_rot, max_rot, min_value, max_value)
		crank_value = clamp(crank_value, min_value, max_value)
		crank_value = roundi(crank_value)
		
		pickable.rotation.y = remap(crank_value, min_value, max_value, min_rot, max_rot)

		prev_rotation = current_rotation
		
		var int1: int = previous_crank_value
		var int2: int = crank_value
		if int1 != int2 and is_instance_valid(%Rumbler):
			previous_crank_value = crank_value
			%Rumbler.rumble_hand(controller)
			%Ratchet.play()
