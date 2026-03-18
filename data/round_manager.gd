extends Node

## The directory to the JSON file containing data for each round.
var round_data_directory: String = "res://data/RoundData.json"

## The fully JSON parsed array.
var round_data: Array

## The queue that can be dynamically pushed and popped for the purpose of spawning enemies.
## Use pop_front() to remove and return the next element in the queue.
var current_queue: Array[String]

## The current round which the game is currently in. When the tower is winded up, this round will be the one that starts.
var current_round: int = 1

## This signal gets called after start_round().
## The purpose is to start spawning enemies with the EnemySpawner that are in the current_queue.
signal round_started

## Parses the JSON data according to the round_data_directory.
func parse_json_data() -> void:
	var file := FileAccess.get_file_as_string(round_data_directory)
	round_data = JSON.parse_string(file)

func _ready() -> void:
	parse_json_data()

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

## Sets the current queue given a round number.
func set_queue(round_num: int) -> void:
	current_queue = return_queue_data(round_num)
	
## Starts the current round. 
## This function can be called both when you start a round new after the intermission/tutorial or if you wanted to restart the round.
func start_round() -> void:
	# First, we gotta clean up the enemies.
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	
	# Then, we need to set the queue
	set_queue(current_round)
	
	# Finally, let the game know that the round has started. 
	# (Example: An EnemySpawner should be listening to this signal getting emitted to know when to start the timer to spawn enemies from current_queue)
	emit_signal("round_started")
