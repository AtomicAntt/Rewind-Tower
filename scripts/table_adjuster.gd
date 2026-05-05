@tool
extends XRToolsPickable
class_name TableAdjuster

@export var min_value: float
@export var max_value: float

var starting_x: float
var starting_z: float

var starting_rot: Vector3

var player: Player

@onready var move_with_table: Node3D = get_tree().get_first_node_in_group("MoveWithTable")

## This is the global position reported AFTER clamp changes, to be used for relative movement.
## TODO: Combine move_with_table.gd with table_adjuster to be a more clean solution.
@onready var reported_global_position: Vector3 = global_position

func _ready():
	if Engine.is_editor_hint():
		return
	
	starting_x = position.x
	starting_z = position.z
	
	starting_rot = rotation
	
	var table_height = SettingsHandler.get_table_height()
	position.y = table_height
	
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if !SettingsHandler.get_has_height_calibrated():
		var player_height = player.camera.position.y * 100
		var calibrated_height = remap(player_height, 100, 175, min_value, max_value)
		
		position.y = calibrated_height
		
		SettingsHandler.set_has_height_calibrated(true)
	
	rotation = starting_rot
	
	position.x = starting_x
	position.z = starting_z
	
	position.y = clamp(position.y, min_value, max_value)
	reported_global_position = global_position
	
	SettingsHandler.set_table_height(position.y)
	SettingsHandler.save()
	
	move_with_table.position.y = position.y
