class_name Enemy
extends PathFollow3D

## Enemy must be a child of a PathFollow3D, which must be a child of a Path3D
@onready var path_3d: Path3D = get_parent()

@onready var path_length: float = path_3d.curve.get_baked_length()

@export var health_bar: ProgressBar

## Amount of HP the enemy has.
@export var enemy_hp: float = 10.0

@onready var max_enemy_hp: float = enemy_hp

## Enemy's speed: how many meters they move per second.
@export var enemy_speed: float = 0.1

## How much damage the enemy does to a defense per second (Or however long the wait_time of the AttackTimer node is).
@export var damage: float = 1.0

const coin_scene: PackedScene = preload("res://scenes/systems/Coin.tscn")

# This represents the current defense that is being attacked. If one exists, it will stop itself and attack the enemy.
var current_defense_attacking: DefenseHitbox = null

var current_defense_troop_attacking: DefenseTroopHitbox = null

func _physics_process(delta: float) -> void:
	# If there isn't a current defense to attack, and the game isn't over, move along the path.
	if not is_instance_valid(current_defense_attacking) and not RoundManager.is_gameover() and not is_instance_valid(current_defense_troop_attacking):
		var new_progress_ratio: float = progress_ratio
		new_progress_ratio += (enemy_speed * delta) / path_length
		
		# Enemy has reached the end, so the game is over.
		if new_progress_ratio >= 1.0:
			RoundManager.set_gameover()
		else:
			progress_ratio = new_progress_ratio
		
		$AttackTimer.stop()
	
	health_bar.value = enemy_hp

func hurt(amount: float) -> void:
	enemy_hp -= amount
	if enemy_hp <= 0:
		
		var coin_amount = randi_range(5, 10)
		
		for i in range(coin_amount):
			var new_coin = coin_scene.instantiate()
			get_parent().add_child(new_coin)
			
			new_coin.global_position = global_position
			
			var coin_direction: Vector3
			coin_direction.x = randi_range(1,3)
			coin_direction.y = randi_range(2,5)
			coin_direction.z = randi_range(1,3)
			new_coin.get_child(0).apply_force(coin_direction * 50)
		
		RoundManager.check_round_won()
		
		queue_free()

func _on_enemy_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("DefenseHitbox"):
		var defense_hitbox: DefenseHitbox = area
		current_defense_attacking = defense_hitbox
		$AttackTimer.start()
	elif area.is_in_group("DefenseTroopHitbox"):
		var defense_troop_hitbox: DefenseTroopHitbox = area
		current_defense_troop_attacking = defense_troop_hitbox
		$AttackTimer.start()

func _on_attack_timer_timeout() -> void:
	if is_instance_valid(current_defense_attacking):
		current_defense_attacking.hurt(damage)
	
	if is_instance_valid(current_defense_troop_attacking):
		current_defense_troop_attacking.hurt(damage)
