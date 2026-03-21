@tool
class_name BearTrap
extends XRToolsPickable

@export var shut_animation: String = "anin_bearTrapShut"
@export var break_animation: String = "anin_bearTrapBreak"
@onready var animation_player: AnimationPlayer = $SM_BearTrap/AnimationPlayer

var enemy_trapping: Enemy
var consumed: bool = false

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
			$Timer.start()

func _on_timer_timeout() -> void:
	animation_player.play(break_animation)
	await animation_player.animation_finished
	if is_instance_valid(enemy_trapping):
		enemy_trapping.stunned = false
	queue_free()
