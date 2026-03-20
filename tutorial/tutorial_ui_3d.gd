@tool
class_name TutorialUI3D
extends XRToolsViewport2DIn3D

## The string the argument [what] in complete(what) that is required to emitted be in order for this node to emit signal [resume]
@export var tutorial_name: String

func _ready() -> void:
	super._ready()
	TutorialSystem.connect("complete", check_signal)

func check_signal(what: String) -> void:
	if what == tutorial_name:
		TutorialSystem.emit_signal("resume")

func hide_tutorial() -> void:
	visible = false

func show_tutorial() -> void:
	visible = true
