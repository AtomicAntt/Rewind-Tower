extends Label3D

# May be a temporary script just to debug what state the game is in. In the future, maybe itll just be used to tell the player what round it is currently.

func _physics_process(delta: float) -> void:
	if RoundManager.in_battle():
		text = "Round " + str(RoundManager.current_round)
	elif RoundManager.in_intermission():
		text = "Intermission (Round " + str(RoundManager.current_round) + ")"
	elif RoundManager.is_gameover():
		text = "Game Over! (Round " + str(RoundManager.current_round) + ")"
