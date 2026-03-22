class_name GlobalAudioManager
extends Node

# DO NOT USE THIS FOR 3D AUDIO (audio played at a specific location)

@export var game_over_audio: AudioStreamPlayer
@export var round_start_audio: AudioStreamPlayer
@export var round_win_audio: AudioStreamPlayer

@export var intermission_music: AudioStreamPlayer
@export var gametime_music: AudioStreamPlayer

func _ready() -> void:
	RoundManager.game_over.connect(play_game_over)
	RoundManager.round_won.connect(play_round_won)
	RoundManager.round_started.connect(play_round_started)

func _process(_delta: float) -> void:
	if RoundManager.in_intermission() and !intermission_music.playing:
		intermission_music.play()
		gametime_music.stop()
	elif RoundManager.in_battle() and !gametime_music.playing and !round_start_audio.playing:
		gametime_music.play()
		intermission_music.stop()
		
	if round_start_audio.playing:
		intermission_music.stop()
	if round_win_audio.playing:
		gametime_music.stop()
		
func play_game_over() -> void:
	game_over_audio.play()

func play_round_won() -> void:
	round_win_audio.play()

func play_round_started() -> void:
	round_start_audio.play()
