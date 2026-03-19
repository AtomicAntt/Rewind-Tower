class_name DefenseTroopHitbox
extends Area3D

@export var crank: Crank

func hurt(amount: float) -> void:
	if amount <= crank.power:
		crank.power -= amount
	else:
		crank.power = 0
