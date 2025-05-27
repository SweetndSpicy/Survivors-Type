class_name BaseEnemy extends CharacterBody2D

#region VARIABLES
var speed :float
var damage :float
#endregion

#region EXPORTED VARIABLES / SETTERS
var health :float= 100 :set = set_health
var enemy_type :Enemy:
	set(new_enemy):
		enemy_type = new_enemy
		$%Body.texture = new_enemy.texture
		health = new_enemy.health
		speed = new_enemy.speed
		damage = new_enemy.damage
@export var enemy_types :Array[Enemy]
@export var warrior: Warrior
#endregion

#region ONREADY
@onready var body: Sprite2D = %Body
#endregion

#region READY
func _ready() -> void:
	if warrior == null:
		print("Warrior is not assigned.")
	enemy_type = enemy_types[randi_range(0,2)]
#endregion
		
func _physics_process(delta: float) -> void:
	var direction :Vector2= position.direction_to(warrior.global_position)
	var desired_velocity :Vector2= direction * speed
	
	move_and_collide(desired_velocity * delta)
	
func take_damage(amount: int) -> void:
	health -= amount
	if health == 0:
		die()
		
func set_health(new_health: int) -> void:
	health = new_health
	health = clampi(health,0, 100)
	var tween :Tween= create_tween()
	tween.tween_property(%HealthBar, "value", new_health, 0.5)
func set_enemy(new_enemy: Enemy):
	pass
func die():
	var pickup_scene :PackedScene= preload("res://Items/Pickups/Scenes/Pickup.tscn")
	var exp_coin_instance := pickup_scene.instantiate()
	exp_coin_instance.item_type = enemy_type.exp_coin
	
	get_tree().current_scene.call_deferred("add_child", exp_coin_instance)
	
	var distance :float= 100.0
	var random_position :Vector2= global_position + distance * (Vector2.RIGHT.rotated(randf_range(0.0, 2 * PI)))
	exp_coin_instance.global_position = random_position
	
	GameManager.safely_queue_free(self)
	%HitBoxCollision.set_deferred("disabled", true)
	set_physics_process(false)
	
func _on_hit_box_body_entered(body: Node2D) -> void:
	take_damage(20)
	
func _on_timer_timeout() -> void:
	%HitBoxCollision.set_deferred("disabled", true)
	%HitBoxCollision.set_deferred("disabled", false)
