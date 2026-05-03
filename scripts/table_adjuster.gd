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

func _ready():
	if Engine.is_editor_hint():
		return
	
	starting_x = position.x
	starting_z = position.z
	
	starting_rot = rotation
	
	var table_height = SettingsHandler.get_table_height()
	position.y = table_height
	
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
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
	
	SettingsHandler.set_table_height(position.y)
	SettingsHandler.save()
	
	move_with_table.position.y = position.y
