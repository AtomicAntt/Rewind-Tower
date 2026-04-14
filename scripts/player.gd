extends Node3D
class_name Player

var xr_interface: XRInterface

@export var coins: int

@onready var coin_slot: XRToolsSnapZone = %CoinSlot

@onready var coin_display: Label3D = %CoinDisplay

@onready var coin_respawn_timer: Timer = %CoinRespawn

@onready var snapzone: XRToolsSnapZone = %Snapzone
@onready var mouth_particles: GPUParticles3D = %MouthParticles

const coin_pickup: PackedScene = preload("res://scenes/CoinPickable.tscn")

var current_coin: XRToolsPickable

var can_spawn_coin: bool = false

signal focus_lost
signal focus_gained
signal pose_recentered

@export var maximum_refresh_rate : int = 90

var xr_is_focussed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR instantiated successfully.")
		var vp : Viewport = get_viewport()
		# Enable XR on our viewport
		vp.use_xr = true

		# Make sure v-sync is off, v-sync is handled by OpenXR
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Enable VRS
		if RenderingServer.get_rendering_device():
			vp.vrs_mode = Viewport.VRS_XR
		elif int(ProjectSettings.get_setting("xr/openxr/foveation_level")) == 0:
			push_warning("OpenXR: Recommend setting Foveation level to High in Project Settings")

		# Connect the OpenXR events
		xr_interface.session_begun.connect(_on_openxr_session_begun)
		xr_interface.session_visible.connect(_on_openxr_visible_state)
		xr_interface.session_focussed.connect(_on_openxr_focused_state)
		xr_interface.session_stopping.connect(_on_openxr_stopping)
		xr_interface.pose_recentered.connect(_on_openxr_pose_recentered)
	else:
		# We couldn't start OpenXR.
		print("OpenXR not instantiated!")
		get_tree().quit()

# Handle OpenXR session ready
func _on_openxr_session_begun() -> void:
	# Get the reported refresh rate
	var current_refresh_rate = xr_interface.get_display_refresh_rate()
	if current_refresh_rate > 0:
		print("OpenXR: Refresh rate reported as ", str(current_refresh_rate))
	else:
		print("OpenXR: No refresh rate given by XR runtime")

	# See if we have a better refresh rate available
	var new_rate = current_refresh_rate
	var available_rates : Array = xr_interface.get_available_display_refresh_rates()
	if available_rates.size() == 0:
		print("OpenXR: Target does not support refresh rate extension")
	elif available_rates.size() == 1:
		# Only one available, so use it
		new_rate = available_rates[0]
	else:
		for rate in available_rates:
			if rate > new_rate and rate <= maximum_refresh_rate:
				new_rate = rate

	# Did we find a better rate?
	if current_refresh_rate != new_rate:
		print("OpenXR: Setting refresh rate to ", str(new_rate))
		xr_interface.set_display_refresh_rate(new_rate)
		current_refresh_rate = new_rate

	# Now match our physics rate
	print("Physics Ticks/s before: " + str(Engine.physics_ticks_per_second))
	Engine.physics_ticks_per_second = current_refresh_rate
	print("Physics Ticks/s now: " + str(Engine.physics_ticks_per_second))

# Handle OpenXR visible state
func _on_openxr_visible_state() -> void:
	# We always pass this state at startup,
	# but the second time we get this it means our player took off their headset
	if xr_is_focussed:
		print("OpenXR lost focus")

		xr_is_focussed = false

		# pause our game
		get_tree().paused = true

		emit_signal("focus_lost")

# Handle OpenXR focused state
func _on_openxr_focused_state() -> void:
	print("OpenXR gained focus")
	xr_is_focussed = true

	# unpause our game
	get_tree().paused = false

	emit_signal("focus_gained")

# Handle OpenXR stopping state
func _on_openxr_stopping() -> void:
	# Our session is being stopped.
	print("OpenXR is stopping")

# Handle OpenXR pose recentered signal
func _on_openxr_pose_recentered() -> void:
	# User recentered view, we have to react to this by recentering the view.
	# This is game implementation dependent.
	XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, true)
	
	emit_signal("pose_recentered")
		

func _process(_delta: float) -> void:
	if coin_slot.has_snapped_object():
		coin_display.text = ("Coins: " + str(coins+1)) # Visually show that the coin on the coin slot is included in the coin count.
	else:
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
	
func _play_coin_pickup() -> void:
	%Coins.play()
		
	%CoinPickupRumbler.rumble_hand(%LeftController)

func _on_left_function_pickup_has_picked_up(_what: Variant) -> void:
	%XRToolsRumbler.rumble_hand(%LeftController)

func _on_right_function_pickup_has_picked_up(_what: Variant) -> void:
	%XRToolsRumbler.rumble_hand(%RightController)
