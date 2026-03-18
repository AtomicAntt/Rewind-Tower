extends Node

## The directory to the JSON file containing data for each round.
var round_data_directory: String = "res://data/RoundData.json"

## The fully JSON parsed array
var round_data: Array

## The queue that can be dynamically pushed and popped for the purpose of spawning enemies
var current_queue: Array[String]

## The current round which the game is currently in. When the tower is winded up, this round will be the one that starts.
var current_round: int = 1

## Parses the JSON data according to the given round_data_directory
func parse_json_data() -> void:
	var file := FileAccess.get_file_as_string(round_data_directory)
	round_data = JSON.parse_string(file)

func _ready() -> void:
	parse_json_data()
	print(return_queue_data(1))
	print(return_queue_data(2))

## Returns an array of all enemies to be spawned in a queue given
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
