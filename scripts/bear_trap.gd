@tool
class_name BearTrap
extends XRToolsPickable

@export var shut_animation: String = "anin_bearTrapShut"
@export var break_animation: String = "anin_bearTrapBreak"
@onready var animation_player: AnimationPlayer = %BearTrapAnimPlayer

var enemy_trapping: Enemy
var consumed: bool = false

@onready var xray: Node3D = %XRAY
var game_manager: Node3D

func _ready():
	game_manager = get_parent_node_3d()

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("EnemyHitbox") and not consumed:
		var enemy: Enemy = area.get_parent()
		if is_instance_valid(enemy):
			consumed = true
			enemy.stunned = true
			# it does 20% of the enemy's max hp
			enemy.hurt(enemy.max_enemy_hp*0.2)
			animation_player.queue(shut_animation)
			enemy_trapping = enemy
			%BearTrapClose.play()
			
			%Timer.start()

func _on_timer_timeout() -> void:
	animation_player.play(break_animation)
	await animation_player.animation_finished
	if is_instance_valid(enemy_trapping):
		enemy_trapping.stunned = false
	queue_free()

func show_xray() -> void:
	xray.visible = true

func hide_xray() -> void:
	xray.visible = false
