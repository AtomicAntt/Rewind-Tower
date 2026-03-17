@tool
class_name DefenseTroop
extends XRToolsPickable

@onready var projectile: PackedScene = preload("res://scenes/DefenseProjectile.tscn")
@onready var shoot_position: Marker3D = $ShootPosition

var closest_enemy_area: Area3D = null

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		closest_enemy_area = find_closest_enemy_area3d()
		if is_instance_valid(closest_enemy_area):
			look_at(find_closest_enemy_area3d().global_position, Vector3.UP, true)

func find_closest_enemy_area3d() -> Area3D:
	var closest_area3d: Area3D = null
	var closest_distance: float = INF
	for enemy_area: Area3D in get_tree().get_nodes_in_group("Enemy"):
		if global_position.distance_to(enemy_area.global_position) < closest_distance:
			closest_area3d = enemy_area
			closest_distance = global_position.distance_to(enemy_area.global_position)
	return closest_area3d

func _on_shoot_timer_timeout() -> void:
	if is_instance_valid(closest_enemy_area) and not Engine.is_editor_hint():
		var projectile_instance: DefenseProjectile = projectile.instantiate()
		get_parent().add_child(projectile_instance)
		projectile_instance.global_position = shoot_position.global_position
		projectile_instance.look_at(closest_enemy_area.global_position)
