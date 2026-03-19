extends Node3D

var xr_interface: XRInterface

@export var coins: int

@onready var coin_slot: Node3D = $XROrigin3D/LeftController/LeftHand/CoinSlot

@onready var coin_display: Label3D = $XROrigin3D/LeftController/LeftHand/CoinDisplay

var coin_pickup: PackedScene = preload("res://scenes/systems/CoinPickable.tscn")

var current_coin: XRToolsPickable

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
		
		
func _process(delta: float) -> void:
	coin_display.text = ("Coins: " + str(coins))
	
	if current_coin != null and current_coin.is_picked_up():
		current_coin.get_parent().reparent(self.get_parent_node_3d())
		current_coin = null
	
	if coins >= 1 and current_coin == null:
		var coin_in_slot = coin_pickup.instantiate()
		coin_slot.add_child(coin_in_slot)
		coins -= 1
		current_coin = coin_in_slot.get_child(0)
