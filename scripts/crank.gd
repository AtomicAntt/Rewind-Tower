extends Node

@export var pickable: XRToolsPickable

var crank_value: float = 0.0
var prev_rotation: float = 0.0

@export var power: float = 0.0

var position: Vector3

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
		
		crank_value += delta_rot
		prev_rotation = current_rotation
		
		power = abs(crank_value)
