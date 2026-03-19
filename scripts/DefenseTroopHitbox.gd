class_name DefenseTroopHitbox
extends Area3D

@export var crank: Crank
@export var defense_troop: DefenseTroop

func _physics_process(_delta: float) -> void:
	if not defense_troop.can_shoot:
		remove_from_group("DefenseTroopHitbox")
	elif not is_in_group("DefenseTroopHitbox"):
		add_to_group("DefenseTroopHitbox")

func hurt(amount: float) -> void:
	if amount <= crank.power:
		crank.power -= amount
	else:
		crank.power = 0

func get_health() -> float:
	return crank.power
