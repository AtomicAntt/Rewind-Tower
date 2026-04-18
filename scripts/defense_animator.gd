extends AnimationPlayer

@export var animationAttack: String
@export var animationHead: String

func _animate() -> void:
	speed_scale = 2
		
	queue(animationAttack)
	if animationHead != "":
		queue(animationHead)
