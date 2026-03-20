class_name TutorialManager
extends Node

## Each entry is the tutorial UI to display.
## The tutorial UI will be listening for a "complete" signal from TutorialSystem given the correct string argument.
## If they do, they can emit from TutorialSystem the "resume" signal which will hide the current element and show the next element.
@export var tutorial_ui_list: Array[TutorialUI3D]

var current_index: int = 0

func _ready() -> void:
	TutorialSystem.connect("resume", instruction_completed)
	
	# We show the initial UI Tutorial
	tutorial_ui_list[0].show_tutorial()
	
func instruction_completed() -> void:
	print("INSTRUCTION COMPLETED")
	tutorial_ui_list[current_index].hide_tutorial()
	current_index += 1
	if not current_index >= tutorial_ui_list.size():
		tutorial_ui_list[current_index].show_tutorial()
