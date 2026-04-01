class_name AutomatWindow
extends Node3D

## How much this unit costs. If the value is -1, this machine is out of order.
@export var cost: int = -1

## After a purchase, how much does the price increase?
@export var cost_increase: int = 0

@export var cost_max: int = -1

var coins_inserted: int = 0

## Name of the item being purchased.
@export var item_name: String = "N/A"

## List any stats here.
@export_multiline var item_description: String

## Insert the actual scene that is purchased here. It should be a XR pickable like a Defense Troop.
@export var item_scene: PackedScene

@onready var item_marker_3d: Marker3D = $ItemMaker3D
@onready var animation_player: AnimationPlayer = $SM_automatWindow/AnimationPlayer
@onready var cost_label: Label3D = $CostLabel
@onready var item_info_label: Label3D = $ItemInfoLabel

var open_animation: String = "SM_automatDoorOpen"
var close_animation: String = "SM_automatDoorClose"

var displayed_item: XRToolsPickable

var original_collision_mask: int
var original_collision_layer: int

## This refreshes the pickable, but you must enable it with enable_displayed_item() if you want players to pick it up.
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
		get_parent().get_parent().add_child.call_deferred(displayed_item)
		displayed_item.global_transform = item_marker_3d.global_transform
		disable_displayed_item()

func refresh_cost_label() -> void:
	if cost == -1:
		cost_label.text = "N/A"
		return
	
	cost_label.text = str(coins_inserted) + "/" + str(cost)
	if coins_inserted >= cost:
		cost_label.modulate = Color("00ff00")
	else:
		cost_label.modulate = Color("ff0000")
	
	item_info_label.text = item_description + "\nCost:\n" + str(cost) + " coins"

func enable_displayed_item() -> void:
	displayed_item.enabled = true
	displayed_item.collision_layer = original_collision_layer
	displayed_item.collision_mask = original_collision_mask
	displayed_item.freeze = false
	
	# More likely than not, their XRToolsPickable collision layer & mask has been set to 0 due to a race conditon..
	# So we have to reset it lol
	displayed_item.original_collision_layer = original_collision_layer
	displayed_item.original_collision_mask = original_collision_mask

## This is for extra optimization
func disable_displayed_item() -> void:
	original_collision_layer = displayed_item.collision_layer
	original_collision_mask = displayed_item.collision_mask
	
	displayed_item.enabled = false
	displayed_item.collision_layer = 0
	displayed_item.collision_mask = 0
	displayed_item.freeze = true

func open_door() -> void:
	refresh_item()
	enable_displayed_item()
	$ItemDetectArea.set_deferred("monitoring", true)
	$ItemDetectArea.set_deferred("process_mode", Node.PROCESS_MODE_ALWAYS)
	$ItemDetectArea.set_collision_mask_value(6, true)
	animation_player.queue(open_animation)
	$Audio/DoorOpen.play()

func close_door() -> void:
	refresh_item()
	#$ItemDetectArea.monitoring = false
	$ItemDetectArea.set_deferred("monitoring", false)
	$ItemDetectArea.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	$ItemDetectArea.set_collision_mask_value(6, false)
	animation_player.queue(close_animation)

func _ready() -> void:
	refresh_item()
	refresh_cost_label()
	
## This is after the player twists the crank and tries to purchase. If you can, purchase.
func check_purchase() -> bool:
	if cost == -1:
		return false
	
	if coins_inserted >= cost:
		coins_inserted -= cost
		open_door()
		if not (cost+cost_increase > cost_max and cost_max != -1):
			cost += cost_increase
		refresh_cost_label()
		
		return true
		
	refresh_cost_label()
	return false

func _on_item_detect_area_body_exited(body: Node3D) -> void:
	if body == displayed_item:
		if displayed_item is DefenseTroop and RoundManager.in_intermission():
			var defense_troop: DefenseTroop = displayed_item
			defense_troop.crank.crank_value = defense_troop.max_power
			defense_troop.crank.power = defense_troop.max_power
			defense_troop.power = defense_troop.max_power
		displayed_item = null
		close_door()
		
		TutorialSystem.emit_signal("complete", "TroopPurchased")

func _on_coin_snap_zone_coin_inserted() -> void:
	coins_inserted += 1
	refresh_cost_label()
	_play_coin_insert()

func _on_twister_interactable_turned(controller: XRController3D) -> void:
	if check_purchase():
		$PurchasedRumbler.rumble_hand(controller)
		$Audio/KnobUnlock.play()
	
func _play_coin_insert() -> void:
	var sound_to_play: int = randi_range(1,5)
	
	match sound_to_play:
		1:
			$Audio/CoinInsert.play()
		2:
			$Audio/CoinInsert1.play()
		3:
			$Audio/CoinInsert2.play()
		4:
			$Audio/CoinInsert3.play()
		5:
			$Audio/CoinInsert4.play()
