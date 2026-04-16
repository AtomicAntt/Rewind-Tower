class_name SnapCrank
extends Node

@export var pickable: XRToolsPickable

var crank_value: float = 0.0
var prev_rotation: float = 0.0

var previous_crank_value: float = 0.0

@export var power: float = 0.0

var position: Vector3

var turnmode: int

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
		
		#Ill make this more generic later
		var pickable_rot_remapped = remap(pickable.rotation.y, -1, 0, 0, 5)
		pickable_rot_remapped = roundi(pickable_rot_remapped)
		pickable_rot_remapped = clamp(pickable_rot_remapped, 1, 5)
		pickable_rot_remapped *= 2
		
		@warning_ignore("narrowing_conversion")
		crank_value = remap(pickable.rotation.y, -.9, .05, 5, 0)
		crank_value = clamp(crank_value, 0, 4)
		crank_value = roundi(crank_value)
		
		pickable.rotation.y = remap(pickable_rot_remapped, 0, 10, -.9, 0.05)

		prev_rotation = current_rotation
		
		var int1: int = previous_crank_value
		var int2: int = crank_value
		if int1 != int2 and is_instance_valid(%Rumbler):
			previous_crank_value = crank_value
			%Rumbler.rumble_hand(controller)
			%Ratchet.play()
