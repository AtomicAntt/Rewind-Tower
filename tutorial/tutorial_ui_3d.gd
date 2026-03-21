@tool
class_name TutorialUI3D
extends XRToolsViewport2DIn3D

## The string the argument [what] in complete(what) that is required to emitted be in order for this node to emit signal [resume]
@export var tutorial_name: String

## Set the tutorial text here
@export_multiline var tutorial_text: String

## This is the tooltip that's attached that will appear/disappear when this does.
@export var tool_tips: Array[Node3D]

## Set the text of the tool tip attached here.
@export var tool_tip_text: Array[String]

var completed: bool = false

## Sorry if it's complex, but if this is true, it will act as an await as no UI shows up until it goes to the next tutorial.
@export var awaiting_next: bool = false

func _ready() -> void:
	super._ready()
	if not Engine.is_editor_hint():
		TutorialSystem.connect("complete", check_signal)
		
		visible = false
		for i in range(tool_tips.size()):
			if is_instance_valid(tool_tips[i]):
				tool_tips[i].visible = false
				var tutorial_ui_2d: TutorialUI2D = tool_tips[i].get_scene_instance()
				tutorial_ui_2d.change_text(tool_tip_text[i])
		
		change_text(tutorial_text)

## Whenever complete signal is emitted, we see if we can resume the tutorial UI
func check_signal(what: String) -> void:
	if what == tutorial_name and not completed and visible:
		completed = true
		TutorialSystem.emit_signal("resume")
	if not visible and what == tutorial_name and not completed and awaiting_next:
		completed = true
		TutorialSystem.emit_signal("resume")

func hide_tutorial() -> void:
	visible = false
	for tool_tip: Node3D in tool_tips:
		if is_instance_valid(tool_tip):
			tool_tip.visible = false

func change_text(new_text: String) -> void:
	var tutorial_ui_2d: TutorialUI2D = get_scene_instance()
	tutorial_ui_2d.change_text(new_text)

func show_tutorial() -> void:
	# Sorry if it's complex, but if this is true, it will act as an await as no UI shows up until it goes to the next tutorial.
	if awaiting_next:
		return
	
	visible = true
	for tool_tip: Node3D in tool_tips:
		if is_instance_valid(tool_tip):
			tool_tip.visible = true
