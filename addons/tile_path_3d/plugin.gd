@tool
extends EditorPlugin


func _enter_tree() -> void:

	add_custom_type("TilePath3D", "Path3D", preload("uid://kjavq4i37ayq"), null)


func _exit_tree() -> void:

	remove_custom_type("TilePath3D")
