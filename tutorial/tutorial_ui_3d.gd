@tool
class_name TutorialUI3D
extends XRToolsViewport2DIn3D

## The string the argument [what] in complete(what) that is required to emitted be in order for this node to emit signal [resume]
@export var tutorial_name: String

## Set the tutorial text here
@export_multiline var tutorial_text: String

## This is the tooltip that's attached that will appear/disappear when this does.
@export var tool_tip: XRToolsViewport2DIn3D

## Set the text of the tool tip attached here.
@export var tool_tip_text: String

var completed: bool = false

func _ready() -> void:
	super._ready()
	if not Engine.is_editor_hint():
		TutorialSystem.connect("complete", check_signal)
		
		visible = false
		if is_instance_valid(tool_tip):
			tool_tip.visible = false
			change_tooltip_text(tool_tip_text)
		
		change_text(tutorial_text)

## Whenever complete signal is emitted, we see if we can resume the tutorial UI
func check_signal(what: String) -> void:
	if what == tutorial_name and not completed:
		completed = true
		TutorialSystem.emit_signal("resume")

func hide_tutorial() -> void:
	visible = false
	if is_instance_valid(tool_tip):
		tool_tip.visible = false

func change_text(new_text: String) -> void:
	var tutorial_ui_2d: TutorialUI2D = get_scene_instance()
	tutorial_ui_2d.change_text(new_text)

func change_tooltip_text(new_text: String) -> void:
	if is_instance_valid(tool_tip):
		var tutorial_ui_2d: TutorialUI2D = tool_tip.get_scene_instance()
		tutorial_ui_2d.change_text(new_text)

func show_tutorial() -> void:
	visible = true
	if is_instance_valid(tool_tip):
		tool_tip.visible = true
