@tool
class_name BearTrapFactory
extends DefenseTroop

@onready var bear_trap: PackedScene = preload("res://scenes/troops/BearTrap.tscn")

var current_bear_trap: BearTrap
var bear_trap_grabbable: bool

@onready var snapzone: XRToolsSnapZone = %SnapZone

## Once it reaches the production_goal value, it can produce a bear trap.
var production_progress: int = 1

## The time it takes to produce a bear trap.
@export var production_time: int = 5

@export var animation_reload: String

# This is the amount we scale down the bear trap when it is in the snap zone.
const scale_down: float = 0.458

var tween: Tween

func _ready():
	super()
	
	snapzone.has_dropped.connect(on_beartrap_grabbed)

func _physics_process(_delta: float) -> void:
	super(_delta)
	
	if is_instance_valid(current_bear_trap) and has_trap():
		# Not intuitive at first, but if pickables are highlighted, it means they are grabbable by the player.
		# In short, the player's hand is close enough to grab it.
		if current_bear_trap._highlighted:
			change_scale_beartrap(1.0)
			#tween = create_tween()
			#bear_trap_grabbable = false # debounce so the tween doesn't get called each frame
			#tween.tween_method(change_scale_beartrap, 1.0, scale_down, 0.1)
		elif not current_bear_trap._highlighted:
			change_scale_beartrap(scale_down)
			#tween = create_tween()
			#bear_trap_grabbable = false# debounce so the tween doesn't get called each frame
			#tween.tween_method(change_scale_beartrap, get_scale_beartrap(), 1.0, 0.1)

func _on_production_timer_timeout() -> void:
	if power <= 0 or has_trap():
		return
	
	production_progress += 1
	lose_power()
	if production_progress >= production_time:
		production_progress = 0
		spawn_beartrap_animation()

## Runs the bear trap reload animation. This should call spawn_beartrap() within the AnimationPlayer.
func spawn_beartrap_animation() -> void:
	animator.queue(animation_reload)

## This should be called in the AnimationPlayer. This spawns the beartrap at the snapzone.
func spawn_beartrap() -> void:
	var bear_trap_instance: BearTrap = bear_trap.instantiate()
	current_bear_trap = bear_trap_instance
	get_parent().add_child(bear_trap_instance)
	bear_trap_instance.global_position = snapzone.global_position
	change_scale_beartrap(scale_down)
	snapzone.pick_up_object(bear_trap_instance)

## We shall connect this to whenever SnapZone drops something
func on_beartrap_grabbed() -> void:
	if is_instance_valid(tween) and tween:
		tween.stop()
	# Just in case the trap hasn't scaled back up in time after grabbing
	change_scale_beartrap(1.0)
	current_bear_trap = null

func has_trap() -> bool:
	if snapzone.has_snapped_object():
		return true
	return false

func change_scale_beartrap(new_scale: float) -> void:
	if is_instance_valid(current_bear_trap) and has_trap():
		current_bear_trap.bear_trap_mesh.scale = Vector3(new_scale, new_scale, new_scale)
		current_bear_trap.xray.scale = Vector3(new_scale, new_scale, new_scale)

func get_scale_beartrap() -> float:
	if is_instance_valid(current_bear_trap) and has_trap():
		return current_bear_trap.bear_trap_mesh.scale.x
	print("Unable to obtain the beartrap scale, defaulting to 1.0")
	return 1.0
