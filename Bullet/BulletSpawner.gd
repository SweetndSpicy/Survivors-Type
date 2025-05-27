extends Node2D

@export var bullet_scene :PackedScene= preload("res://Items/Weapons/Scenes/Bullet.tscn")
@onready var bullet_timer :Timer= %Timer

func _ready() -> void:
	bullet_timer.timeout.connect(_on_bullet_cooldown_timeout)
	bullet_timer.start()

func _on_bullet_cooldown_timeout() -> void:
	var closest = find_closest_enemy()
	if closest == null:
		return
		
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.set_target(closest.global_position)
	
func find_closest_enemy() -> Node2D:
	var closest_enemy = null
	var shortest_distance := INF

	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if not is_instance_valid(enemy):
			continue
		var distance = global_position.distance_to(enemy.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_enemy = enemy

	return closest_enemy
