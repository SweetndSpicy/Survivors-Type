extends Area2D

#region VARIABLES
var is_magnet_active = false
var speed :float= 450.0
#endregion
#region EXPORTED VARIABLES/SETTERS
@export var item_type :Pickup
#endregion
#region ONREADY
@onready var warrior_reference :Warrior= GameManager.safely_get_node("/root/Game/Warrior")
@onready var expbar_reference :ExpBar= GameManager.safely_get_node("/root/Game/CanvasLayer/ExpBar")
@onready var sprite_2d: Sprite2D = %Sprite2D
#endregion

func _ready() -> void:
	floating_animation()
	$Sprite2D.texture = item_type.texture
func _physics_process(delta: float) -> void:
	if is_magnet_active:
		var direction :Vector2= global_position.direction_to(warrior_reference.global_position)
		position += direction * speed * delta
func floating_animation():
	var tween :Tween= create_tween().set_loops()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite_2d, "position", Vector2(0.0, -8.0), 0.8)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(sprite_2d, "position", Vector2(0.0, 8.0), 0.8)
func pickup_animation():
	var direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var pushback :Vector2
	if direction >= 0.0:
		pushback = global_position + Vector2(100.0, 0.0)
	else:
		pushback = global_position + Vector2(-100.0, 0.0)
		
	var tween :Tween= create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", pushback, 0.7)
	tween.tween_callback(Callable(self, "magnet_animation"))
	tween.set_parallel()
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, 0.7)
	tween.finished.connect(func() -> void:
		GameManager.safely_queue_free(self)
		)
	%CollisionShape2D.set_deferred("disabled", true)
func magnet_animation():
	is_magnet_active = true
func _on_body_entered(body: Node2D) -> void:
	pickup_animation()
	on_pickup()
func on_pickup():
	if item_type is ExpCoin:
		expbar_reference.current_exp += item_type.xp_amount
