class_name Warrior extends CharacterBody2D

#region Variables
var speed :float= 650
var acceleration :float= 1000
var deceleration :float= 800
#endregion

#region Onready
@onready var body: AnimatedSprite2D = %Body
@onready var healthbar: ProgressBar = $Healthbar
#endregion



func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction :Vector2= Input.get_vector("move_left","move_right","move_up","move_down")
	var has_direction := direction.length() > 0.0
	var desired_velocity :Vector2= direction * speed
	
	if has_direction:
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
		body.rotation= rotate_toward(rotation, direction.angle(), 0.5 * delta)
		body.play("Run")
		body.flip_h = direction.x < 0.0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		
	if velocity == Vector2.ZERO:
		body.play("Idle")

	move_and_slide()
