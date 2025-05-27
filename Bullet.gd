class_name ClassicBullet
extends Area2D

@export var damage: float
@export var bullet_speed: float
@onready var hitting_sound: AudioStreamPlayer2D = %HittingSound

var direction := Vector2.ZERO

func _ready() -> void:
	body_entered.connect(func(body: BaseEnemy) -> void:
		explode(body)
	)

func _physics_process(delta: float) -> void:
	position += direction * bullet_speed * delta

func set_target(target_position: Vector2) -> void:
	direction = global_position.direction_to(target_position)

func explode(body: BaseEnemy):
	body.take_damage(damage)
	hitting_sound.play()
	queue_free()
