class_name TowerCrank
extends Crank

## The required power the crank needs to start the next round.
@export var required_power: float = 20.0

# I will use this to remember the progress ratios of enemies when game over state occurs
var enemies_dict: Dictionary = {}

func _ready() -> void:
	RoundManager.game_over.connect(record_enemies_dict)

func _physics_process(_delta) -> void:
	
	super._physics_process(_delta)
	
	# Lets make a funny visual where cranking up to intermission from game over state will rewind the enemies
	if RoundManager.is_gameover():
		for enemy: Enemy in enemies_dict:
			if is_instance_valid(enemy):
				var new_progress_ratio: float = (enemies_dict[enemy] - (power/required_power))
				if new_progress_ratio <= 0:
					enemy.visible = false
				else:
					enemy.progress_ratio = new_progress_ratio
					enemy.visible = true
	
	if power >= required_power:
		if RoundManager.in_battle():
			RoundManager.start_intermission()
		elif RoundManager.in_intermission():
			RoundManager.start_round()
			TutorialSystem.emit_signal("complete", "CrankTower")
		elif RoundManager.is_gameover():
			RoundManager.start_intermission()
			
		crank_value = 0.0
		power = 0.0
		# This should prevent cranks from moving.
		pickable.drop()
	
	
	%ProgressBar.value = power

func record_enemies_dict() -> void:
	# Set these values so that progress ratios of enemies are not affected initially from overturning from previous winds
	crank_value = 0.0
	power = 0.0
	
	var new_dict: Dictionary = {}
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		new_dict[enemy] = enemy.progress_ratio
	
	enemies_dict = new_dict
