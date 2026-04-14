extends Node3D
class_name Cigarette

var player: Player

var in_mouth: bool = false

var player_smoked: bool = false
var smoke_emitted: bool = false
var inhaled: bool = false

@onready var pickable: XRToolsPickable = %Pickable

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	if pickable.is_picked_up():
		%TipParticles.emitting = true
	else:
		%TipParticles.emitting = false
		
	if player.snapzone.has_snapped_object():
		player.mouth_particles.emitting = false
		player_smoked = true
		in_mouth = true
		smoke_emitted = false
		if not inhaled:
			%Inhale.play()
			inhaled = true
	else:
		if player_smoked and not smoke_emitted:
			player.mouth_particles.emitting = true
			%Exhale.play()
			smoke_emitted = true
		in_mouth = false
		inhaled = false
