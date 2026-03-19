class_name DefenseHitbox
extends Area3D

## The amount of health this entity has.
@export var health: float = 10.0
@onready var max_health: float = health

## This must be the actual entity itself that will be destroyed once HP reaches 0. If none is assigned, it will assume itself.
@export var entity: Node3D = null

@export var health_bar: ProgressBar = null

func _ready() -> void:
	# This is just in case we forget to assign this node to the correct group.
	# It needs to be in this group so that an enemy may stop and attack this node.
	if not is_in_group("DefenseHitbox"):
		add_to_group("DefenseHitbox")
	
	# By default, if no entity is set, it will assume the hitbox itself.
	if not is_instance_valid(entity):
		entity = self

func hurt(amount: float) -> void:
	health -= amount
	if health <= 0:
		death()
	
	if is_instance_valid(health_bar):
		health_bar.value = health

func death() -> void:
	entity.visible = false
	remove_from_group("DefenseHitbox")

func restore() -> void:
	entity.visible = true
	add_to_group("DefenseHitbox")
	health = max_health
	
	if is_instance_valid(health_bar):
		health_bar.value = health
