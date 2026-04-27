@warning_ignore("missing_tool")
extends XRToolsPickable
class_name TableAdjuster

@export var min_value: float
@export var max_value: float

var starting_x: float
var starting_z: float

var starting_rot: Vector3

func _ready():
	starting_x = position.x
	starting_z = position.z
	
	starting_rot = rotation
	
	var table_height = SettingsHandler.get_table_height()
	position.y = table_height

func _process(_delta: float) -> void:
	rotation = starting_rot
	
	position.x = starting_x
	position.z = starting_z
	
	position.y = clamp(position.y, min_value, max_value)
	
	SettingsHandler.set_table_height(position.y)
	SettingsHandler.save()
