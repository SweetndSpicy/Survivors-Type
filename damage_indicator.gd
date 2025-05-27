class_name DamageIndicator extends Node2D

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func display_amount(amount: float) -> void:
	position.x += randf_range(-40.0, 40.0)
	rich_text_label.text = str(-amount)
	animation_player.play("floating_damage")
