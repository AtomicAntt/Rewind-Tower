class_name AutomatWindow
extends Node3D

## How much this unit costs. If the value is -1, this machine is out of order.
@export var cost: int = -1

var coins_inserted: int = 0

## Name of the item being purchased.
@export var item_name: String = "N/A"

## List any stats here.
@export_multiline var item_description: String

## Insert the actual scene that is purchased here. It should be a XR pickable like a Defense Troop.
@export var item_scene: PackedScene

@onready var item_marker_3d: Marker3D = $ItemMaker3D
@onready var animation_player: AnimationPlayer = $SM_automatWindow/AnimationPlayer

var open_animation: String = "SM_automatDoorOpen"
var close_animation: String = "SM_automatDoorClose"

var displayed_item: XRToolsPickable

## This refreshes the pickable, but you must enable it if you want players to pick it up.
func refresh_item() -> void:
	if is_instance_valid(displayed_item):
		displayed_item.queue_free()
	
	var item_instance: XRToolsPickable
	
	if is_instance_valid(item_scene):
		item_instance = item_scene.instantiate()
	else:
		return
	
	if is_instance_valid(item_instance):
		displayed_item = item_instance
		get_parent().get_parent().add_child(displayed_item)
		displayed_item.global_position = item_marker_3d.global_position
		displayed_item.enabled = false

func open_door() -> void:
	refresh_item()
	displayed_item.enabled = true
	animation_player.queue(open_animation)

func close_door() -> void:
	refresh_item()
	animation_player.queue(close_animation)

func _ready() -> void:
	refresh_item()

## This is after the player twists the crank and tries to purchase. If you can, purchase.
func check_purchase() -> void:
	if cost == -1:
		return
	
	if coins_inserted >= cost:
		coins_inserted -= cost
		open_door()

func _on_item_detect_area_body_exited(body: Node3D) -> void:
	if body == displayed_item:
		close_door()

func _on_coin_snap_zone_coin_inserted() -> void:
	coins_inserted += 1
