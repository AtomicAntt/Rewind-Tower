@tool
class_name BearTrapFactory
extends DefenseTroop

@onready var bear_trap: PackedScene = preload("res://scenes/troops/BearTrap.tscn")

@onready var snapzone: XRToolsSnapZone = %SnapZone

## Once it reaches the production_goal value, it can produce a bear trap.
var production_progress: int = 1

## The time it takes to produce a bear trap.
@export var production_time: int = 5

@export var animation_reload: String

# This is the amount we scale down the bear trap when it is in the snap zone.
const scale_down: float = 0.458

#func _physics_process(_delta: float) -> void:
	#super(_delta)

func _on_production_timer_timeout() -> void:
	if power <= 0 or has_trap():
		return
	
	production_progress += 1
	if production_progress >= production_time:
		production_progress = 0
		spawn_beartrap_animation()

## Runs the bear trap reload animation. This should call spawn_beartrap() within the AnimationPlayer.
func spawn_beartrap_animation() -> void:
	animator.queue(animation_reload)

## This should be called in the AnimationPlayer. This spawns the beartrap at the snapzone.
func spawn_beartrap() -> void:
	var bear_trap_instance: BearTrap = bear_trap.instantiate()
	bear_trap_instance.global_position = snapzone.global_position
	snapzone.pick_up(bear_trap_instance)
	get_parent().add_child(bear_trap_instance)

func has_trap() -> bool:
	if snapzone.has_snapped_object():
		return true
	return false
