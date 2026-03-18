class_name TowerCrank
extends Crank

## The required power the crank needs to start the next round.
@export var required_power: float = 20.0

func _physics_process(_delta) -> void:
	super._physics_process(_delta)
	
	if power >= required_power:
		if RoundManager.in_battle():
			RoundManager.start_intermission()
		elif RoundManager.in_intermission():
			RoundManager.start_round()
			
		crank_value = 0
		power = 0
	
	$SubViewport/ProgressBar.value = power
