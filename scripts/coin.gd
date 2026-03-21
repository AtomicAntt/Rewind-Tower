extends Node3D

var move_towards_hand: bool = false;

var hand: XRController3D
var player: Node3D

@export var coin_speed: float = 25.0
@export var acceleration: float = 20.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	hand = XRHelpers.get_left_controller(player)
	
	await get_tree().create_timer(randf_range(0.5, 1.0)).timeout
	move_towards_hand = true
	$RigidBody3D.gravity_scale = 0

func _physics_process(delta: float) -> void:
	if move_towards_hand:
		var direction = (hand.global_position - $RigidBody3D.global_position).normalized()
		$RigidBody3D.apply_force(direction * coin_speed)
		coin_speed += acceleration * delta

func _on_object_in_range(area: Area3D) -> void:
	if area.get_parent_node_3d() is XRController3D:
		$XRToolsRumbler.rumble_hand(hand)
		player._play_coin_pickup()
		player.coins += 1
		queue_free()
