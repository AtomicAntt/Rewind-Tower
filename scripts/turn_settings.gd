extends Node
class_name TurnSettings

var turn_mode_value
var smooth_speed_value

@onready var crank: SnapCrank = %Crank

@onready var knob: KnobInteractable = %Knob

func _ready() -> void:
	turn_mode_value = SettingsHandler.get_turn_mode()
	smooth_speed_value = SettingsHandler.get_smooth_speed()
	
	var crank_min = crank.min_rot
	var crank_max = crank.max_rot
	
	var value_min = crank.min_value
	var value_max = crank.max_value
	
	crank.pickable.rotation.y = remap(turn_mode_value,value_min, value_max, crank_min, crank_max)
	crank.crank_value = turn_mode_value
	
	print(crank.crank_value)
	
	knob.value = smooth_speed_value
	
	knob.delta_rot = -smooth_speed_value / 2.75
	
	knob.prev_rotation = -smooth_speed_value
	
	knob.rotation = knob.delta_rot
	

func _process(delta: float) -> void:
	turn_mode_value = crank.crank_value
	smooth_speed_value = knob.value
	
	SettingsHandler.set_turn_mode(turn_mode_value)
	SettingsHandler.set_smooth_speed(smooth_speed_value)
	
	SettingsHandler.save()
