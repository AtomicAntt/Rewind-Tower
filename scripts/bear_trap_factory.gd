@tool
class_name BearTrapFactory
extends DefenseTroop

@onready var bear_trap: PackedScene = preload("res://scenes/troops/BearTrap.tscn")

## The current bear trap pickable that should be snapped onto the SnapZone, ready to be picked up.
var current_bear_trap: BearTrap

## The snap zone where we will store the bear trap.
@onready var snapzone: XRToolsSnapZone = %SnapZone

## This is the visual mesh from the animation. We want to hide this dummy bear trap after hiding it.
@onready var bear_trap_mesh: MeshInstance3D = %SM_bearTrap

## Once it reaches the production_goal value, it can produce a bear trap.
var production_progress: int = 1

## The time it takes to produce a bear trap.
@export var production_time: int = 5

@export var animation_reload: String

## This is the amount we scale down the bear trap when it is in the snap zone.
const scale_down: float = 0.458

## Animates the pickable bear trap to prompt player grab by shrinking/rescaling it.
var tween: Tween

func _ready():
	super()
	
	snapzone.has_dropped.connect(on_beartrap_grabbed)

func _on_production_timer_timeout() -> void:
	if power <= 0 or has_trap() or is_picked_up():
		return
	
	production_progress += 1
	lose_power()
	if production_progress >= production_time:
		production_progress = 0
		spawn_beartrap_animation()

## Runs the bear trap reload animation. This should call spawn_beartrap() within the AnimationPlayer.
func spawn_beartrap_animation() -> void:
	# Show the dummy bear trap mesh we used in the animation again.
	bear_trap_mesh.visible = true
	
	animator.queue(animation_reload)

## This should be called in the AnimationPlayer. 
## This spawns the beartrap pickable at the snapzone to replace the dummy bear trap mesh for visual purposes.
func spawn_beartrap() -> void:
	# First, we gotta hide the dummy bear trap mesh we used in the animation.
	bear_trap_mesh.visible = false
	
	# Now instantiate/spawn the pickable bear trap.
	var bear_trap_instance: BearTrap = bear_trap.instantiate()
	current_bear_trap = bear_trap_instance
	bear_trap_instance.global_position = snapzone.global_position
	var game_manager = get_tree().get_first_node_in_group("GameManager")
	game_manager.add_child(bear_trap_instance)
	
	# Not intuitive at first, but if pickables are highlighted, it means they are grabbable by the player.
	# In short, we prompt grabs if the player can pick up the bear trap.
	bear_trap_instance.highlight_updated.connect(prompt_grab)
	
	# Forcefully make the SnapZone in our factory pick up this pickable bear trap.
	snapzone.pick_up_object(bear_trap_instance)
	change_scale_beartrap(scale_down)

## We shall connect this to whenever SnapZone drops something
func on_beartrap_grabbed() -> void:
	if is_instance_valid(tween) and tween:
		tween.stop()
	# We don't want to prompt grabs since the bear trap that's been grabbed already.
	current_bear_trap.highlight_updated.disconnect(prompt_grab)
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

## Animates the pickable bear trap to prompt player grab using a tween to rescale it.
func prompt_grab(_pickable, _enable) -> void:
	if is_instance_valid(current_bear_trap) and has_trap():
		# Not intuitive at first, but if pickables are highlighted, it means they are grabbable by the player.
		# In short, the player's hand is close enough to grab it.
		if current_bear_trap._highlighted:
			tween = create_tween()
			tween.tween_method(change_scale_beartrap, get_scale_beartrap(), 1.0, 0.1)
		else:
			tween = create_tween()
			tween.tween_method(change_scale_beartrap, 1.0, scale_down, 0.1)
