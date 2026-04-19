extends Node
class_name TurnSettings

var turn_mode_value
var smooth_speed_value

@onready var crank: SnapCrank = %Crank

@onready var knob: KnobInteractable = %Knob

func _ready() -> void:
	turn_mode_value = SettingsHandler.get_turn_mode()
	smooth_speed_value = SettingsHandler.get_smooth_speed()
	
	crank.pickable.rotation.y = remap(turn_mode_value,5, 0, -.9, .05)
	crank.crank_value = turn_mode_value
	
	
	knob.value = smooth_speed_value
	
	knob.delta_rot = -smooth_speed_value / 2.75
	
	knob.prev_rotation = -smooth_speed_value
	
	knob.rotation = knob.delta_rot
	

func _process(delta: float) -> void:
	turn_mode_value = crank.crank_value
	smooth_speed_value = knob.value
	
	print(crank.pickable.rotation.y)
	
	SettingsHandler.set_turn_mode(turn_mode_value)
	SettingsHandler.set_smooth_speed(smooth_speed_value)
	
	SettingsHandler.save()
