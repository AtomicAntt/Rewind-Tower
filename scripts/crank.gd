extends Node

@export var pickable : XRToolsPickable

var crankValue : float = 0.0
var prevRotation : float = 0.0

var position : Vector3

func _ready() -> void:
	position = pickable.position

func _process(_delta) -> void:
	pickable.position = position
	pickable.rotation = Vector3(0, pickable.rotation.y, 0)
	
	if pickable.is_picked_up():
		var controller : XRController3D = pickable.get_picked_up_by_controller()
		
		pickable.look_at(controller.global_position)
		
		pickable.rotation.x = 0
		pickable.rotation.z = 0
		
		var current_rotation = pickable.rotation.y
		var deltaRot = current_rotation - prevRotation
		
		# Fix wraparound
		if deltaRot > PI:
			deltaRot -= TAU
		elif deltaRot < -PI:
			deltaRot += TAU
		
		crankValue += deltaRot
		prevRotation = current_rotation
		print(crankValue)
