extends Node

@onready var pickable: XRToolsPickable = $XRToolsPickable

@onready var drop_timer: Timer = $DropTimer

var player: Node3D

func _ready() -> void:
	player = get_parent().get_node("Player")

func _on_drop_timer_timeout() -> void:
	player.coins += 1
	queue_free()
	
func _dropped() -> void:
	drop_timer.start()
