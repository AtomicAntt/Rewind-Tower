extends Node3D

var xr_interface: XRInterface

@export var coins: int

@onready var coin_slot: XRToolsSnapZone = $XROrigin3D/LeftController/LeftHand/CoinSlot

@onready var coin_display: Label3D = $XROrigin3D/LeftController/LeftHand/CoinDisplay

@onready var coin_respawn_timer: Timer = $XROrigin3D/LeftController/LeftHand/CoinSlot/CoinRespawn

var coin_pickup: PackedScene = preload("res://scenes/systems/CoinPickable.tscn")

var current_coin: XRToolsPickable

var can_spawn_coin: bool = false

func _ready():
	
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
		
		
func _process(_delta: float) -> void:
	coin_display.text = ("Coins: " + str(coins))
	
	if current_coin != null and !coin_slot.has_snapped_object():
		coins -= 1
		current_coin.get_parent_node_3d()._dropped()
		current_coin = null
		coin_respawn_timer.start()
	
	if coins >= 1 and current_coin == null and can_spawn_coin and !coin_slot.has_snapped_object():
		can_spawn_coin = false
		var coin_in_slot = coin_pickup.instantiate()
		get_parent_node_3d().add_child(coin_in_slot)
		
		current_coin = coin_in_slot.get_child(0)
		
		coin_in_slot.visible = true
		
		coin_in_slot.global_position = coin_slot.global_position
		coin_in_slot.rotation = coin_slot.rotation

func _on_coin_respawn_timeout() -> void:
	can_spawn_coin = true
