extends Node
class_name HeightManager

var slider: XRToolsInteractableSlider

@export var min_height: float
@export var max_height: float

var slider_value: float

var table: Node3D

func _ready() -> void:
	table = get_tree().get_first_node_in_group("Table")
	slider = get_tree().get_first_node_in_group("AdjustSlider")

func _process(_delta: float) -> void:
	slider_value = slider.position.x
	slider_value = remap(slider_value, slider.slider_limit_min, slider.slider_limit_max, min_height, max_height)
	
	print(slider_value)
	
	table.position.y = slider_value
