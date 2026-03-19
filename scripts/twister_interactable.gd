class_name TwisterInteractable
extends Node3D

@export var pickable: XRToolsPickable

var twister_value: float = 0.0

var value: float = 0.0
var value_threshold: float = 120.0

var prev_rotation: float = 0.0

func _ready() -> void:
	pickable.global_position = global_position

func _physics_process(_delta) -> void:
	# basically crank but z
	pickable.global_position = global_position
	pickable.rotation = Vector3(0, 0, pickable.rotation.z)
	
	if pickable.is_picked_up():
		var controller: XRController3D = pickable.get_picked_up_by_controller()
		
		pickable.rotation.z = controller.rotation.z
		
		var current_rotation = pickable.rotation.z
		var delta_rot = current_rotation - prev_rotation
		
		# Fix wraparound
		if delta_rot > PI:
			delta_rot -= TAU
		elif delta_rot < -PI:
			delta_rot += TAU
		
		twister_value += delta_rot
		value = abs(twister_value)
		print("Value: " + str(value))
		
	
	
