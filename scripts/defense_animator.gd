extends Node

@export var animator: AnimationPlayer

@export var animationAttack: String
@export var animationHead: String

@export var defenseTroop: Node3D

func _animate() -> void:
	animator.speed_scale = 2
		
	animator.queue(animationAttack)
	animator.queue(animationHead)
