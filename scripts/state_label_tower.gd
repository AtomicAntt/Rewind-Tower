extends Label3D

func _physics_process(_delta: float) -> void:
	if RoundManager.in_battle():
		text = "Restart round? (Round " + str(RoundManager.current_round) + ")"
	elif RoundManager.in_intermission():
		text = "Start round " + str(RoundManager.current_round) + "?"
	elif RoundManager.is_gameover():
		text = "Restart round? (Round " + str(RoundManager.current_round) + ")"
	elif RoundManager.is_won():
		text = "Congratulations, you win!"
