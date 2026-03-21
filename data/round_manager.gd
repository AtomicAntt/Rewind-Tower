extends Node

enum States {INTERMISSION, BATTLE, GAMEOVER}

## Current state the game is in.
var state: States = States.INTERMISSION

## The directory to the JSON file containing data for each round.
var round_data_directory: String = "res://data/RoundData.json"

## The fully JSON parsed array.
var round_data: Array

## The queue containing enemy names that can be dynamically pushed and popped for the purpose of spawning enemies.
var current_queue: Array[String]

## The current round which the game is currently in. When the tower is winded up, this round will be the one that starts.
var current_round: int = 1

## This signal gets called after start_round().
## The purpose is to start spawning enemies with the EnemySpawner that are in the current_queue.
signal round_started

signal intermission_started

signal game_over

## Parses the JSON data according to the round_data_directory.
func parse_json_data() -> void:
	var file := FileAccess.get_file_as_string(round_data_directory)
	round_data = JSON.parse_string(file)

func _ready() -> void:
	parse_json_data()
	
	# Debug code: Lets say the first round starts right away, as soon as you enter the game
	#start_round()

## Returns an array of all enemies to be spawned in a queue given.
## Example: return_queue_data(#) -> ["Raider", "Raider", "Wolf", "Wolf"] (2 raiders, then 2 wolves)
func return_queue_data(round_num: int) -> Array[String]:
	var dict: Dictionary = round_data[round_num-1]
	var enemies_array: Array = dict["Enemies"]
	var queue: Array[String] = []
	
	for enemy_dict: Dictionary in enemies_array:
		for enemy_name: String in enemy_dict:
			# The amount of that specific enemy should be the value.
			for i in enemy_dict[enemy_name]:
				queue.append(enemy_name)
	
	return queue

## Sets the current queue of enemies given a round number.
func set_queue(round_num: int) -> void:
	current_queue = return_queue_data(round_num)
	
## Starts the current round. 
## This function can be called for both when you start a round new after the intermission/tutorial or if you wanted to restart the round.
func start_round() -> void:
	# Set the game state
	set_battle()
	
	# Clean up the enemies.
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	
	# Then, we need to set the queue
	set_queue(current_round)
	
	# Finally, let the game know that the round has started. 
	# (Example: An EnemySpawner should be listening to this signal getting emitted to know when to start the timer to spawn enemies from current_queue)
	emit_signal("round_started")

func start_intermission() -> void:
	# Set game state
	set_intermission()
	
	# Clean up the enemies.
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
		
	# Restore gate.
	var castle_gate: DefenseHitbox = get_tree().get_first_node_in_group("CastleGate")
	castle_gate.restore()
		
	emit_signal("intermission_started")

## Call this from enemy each time they die.
## This will move the game to the next round if no enemies are in the queue + no enemies alive.
func check_round_won() -> void:
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		# Not all enemies may be freed yet, so just check their health to see if all are dead.
		if enemy.enemy_hp > 0 and is_instance_valid(enemy):
			return
	
	if current_queue.is_empty():
		current_round += 1
		set_intermission()

## Call this to check if the game state is currently in intermission.
func in_intermission() -> bool:
	return state == States.INTERMISSION

func in_battle() -> bool:
	return state == States.BATTLE

func is_gameover() -> bool:
	return state == States.GAMEOVER

func set_intermission() -> void:
	state = States.INTERMISSION
	
	TutorialSystem.emit_signal("complete", "IntermissionEntered")

func set_battle() -> void:
	state = States.BATTLE

func set_gameover() -> void:
	state = States.GAMEOVER
	emit_signal("game_over")
