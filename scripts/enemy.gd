class_name Enemy
extends PathFollow3D

## Enemy must be a child of a PathFollow3D, which must be a child of a Path3D
@onready var path_3d: Path3D = get_parent()

@onready var path_length: float = path_3d.curve.get_baked_length()

@export var health_bar: ProgressBar
@export var health_bar_sprite: Sprite3D

## Amount of HP the enemy has.
@export var enemy_hp: float = 10.0

@onready var max_enemy_hp: float = enemy_hp

## Enemy's speed: how many meters they move per second.
@export var enemy_speed: float = 0.1

## How much damage the enemy does to a defense per second (Or however long the wait_time of the AttackTimer node is).
@export var damage: float = 1.0

var is_dead: bool = false

# solely used by the bear trap
var stunned: bool = false

@export var animation_player: AnimationPlayer
@export var run_anim: String
@export var attack_anim: String
@export var death_anim: String

## Drops this amount of coins.
@export var coin_value: int = 1

const coin_scene: PackedScene = preload("res://scenes/systems/Coin.tscn")

# This represents the current defense that is being attacked. If one exists, it will stop itself and attack the enemy.
var current_defense_attacking: DefenseHitbox = null

var current_defense_troop_attacking: DefenseTroopHitbox = null

func _ready() -> void:
	health_bar.max_value = max_enemy_hp
	health_bar.value = enemy_hp

func _physics_process(delta: float) -> void:
	# If there isn't a current defense to attack, and the game isn't over, move along the path.
	if not check_if_valid_attack(current_defense_attacking, current_defense_troop_attacking) and not RoundManager.is_gameover() and not is_dead and not stunned:
		var new_progress_ratio: float = progress_ratio
		new_progress_ratio += (enemy_speed * delta) / path_length
		
		# Enemy has reached the end, so the game is over.
		if new_progress_ratio >= 1.0:
			RoundManager.set_gameover()
		else:
			progress_ratio = new_progress_ratio
		
		$AttackTimer.stop()
		
		if is_instance_valid(animation_player):
			if animation_player.current_animation != run_anim:
				animation_player.play(run_anim)
	
	health_bar.value = enemy_hp

func hurt(amount: float) -> void:
	if is_dead or RoundManager.is_gameover():
		return
	
	enemy_hp -= amount
	if enemy_hp <= 0:
		
		var coin_amount = coin_value
		
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
		
		death()

func death() -> void:
	is_dead = true
	$EnemyHitbox.remove_from_group("EnemyHitbox")
	if is_instance_valid(animation_player):
		animation_player.stop()
		animation_player.play(death_anim)
	
	if is_instance_valid(health_bar_sprite):
		health_bar_sprite.visible = false
	
	if is_instance_valid($Audio):
		var picked_audio: int = randi_range(1, 4)
		match picked_audio:
			1:
				$Audio/EnemyBreak.play()
			2:
				$Audio/EnemyBreak1.play()
			3:
				$Audio/EnemyBreak2.play()
			4:
				$Audio/EnemyBreak3.play()
	
	#await get_tree().create_timer(1.0).timeout
	await animation_player.animation_finished
	
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
	if is_dead:
		return
	
	if is_instance_valid(current_defense_attacking):
		if is_instance_valid(animation_player):
			animation_player.play(attack_anim)
		current_defense_attacking.hurt(damage)
		if current_defense_attacking.health <= 0: 
			current_defense_attacking = null
		
	if is_instance_valid(current_defense_troop_attacking):
		if is_instance_valid(animation_player):
			animation_player.play(attack_anim)
		current_defense_troop_attacking.hurt(damage)
		if current_defense_troop_attacking.get_health() <= 0: 
			current_defense_troop_attacking = null

func check_if_valid_attack(defense_hitbox: DefenseHitbox, defense_troop_hitbox: DefenseTroopHitbox) -> bool:
	if is_dead:
		return false
	
	if is_instance_valid(defense_hitbox):
		if not defense_hitbox.is_in_group("DefenseHitbox"):
			current_defense_attacking = null
			return false
	
	if is_instance_valid(defense_troop_hitbox):
		if not defense_troop_hitbox.is_in_group("DefenseTroopHitbox"):
			current_defense_troop_attacking = null
			return false
	
	if not is_instance_valid(defense_hitbox) and not is_instance_valid(defense_troop_hitbox):
		return false
	
	var contains_hitbox: bool = false
	
	for area in $EnemyHitbox.get_overlapping_areas():
		if area is DefenseHitbox or DefenseTroopHitbox:
			contains_hitbox = true
		
	if not contains_hitbox:
		current_defense_attacking = null
		current_defense_troop_attacking = null
		return false
	
	return true
