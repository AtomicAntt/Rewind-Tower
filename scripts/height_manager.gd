extends Node
class_name HeightManager

var slider: Node3D
var slider_value: float

var has_set_position: bool = false

func _ready() -> void:
	slider = get_tree().get_first_node_in_group("AdjustSlider")
	
	slider_value = SettingsHandler.get_table_height()

func _process(_delta: float) -> void:
	if !has_set_position:
		slider.position.x = slider_value
		has_set_position = true
	
	slider_value = slider.position.x
	#print(slider_value)
	
	SettingsHandler.set_table_height(slider_value)
	SettingsHandler.save()
