class_name GlobalAudioManager
extends Node

# DO NOT USE THIS FOR 3D AUDIO (audio played at a specific location)

@export var game_over_audio: AudioStreamPlayer
@export var round_start_audio: AudioStreamPlayer
@export var round_win_audio: AudioStreamPlayer

func _ready() -> void:
	RoundManager.game_over.connect(play_game_over)
	RoundManager.round_won.connect(play_round_won)
	RoundManager.round_started.connect(play_round_started)

func play_game_over() -> void:
	game_over_audio.play()

func play_round_won() -> void:
	round_win_audio.play()

func play_round_started() -> void:
	round_start_audio.play()
