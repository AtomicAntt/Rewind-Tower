extends Node

@onready var slider: XRToolsInteractableSlider = %AdjustSlider

@export var min_height: float
@export var max_height: float

var slider_value: float

func _process(delta: float) -> void:
	slider_value = slider.position.x
	slider_value = remap(slider_value, slider.slider_limit_min, slider.slider_limit_max, min_height, max_height)
	
	print(slider_value)
	
	self.position.y = slider_value
