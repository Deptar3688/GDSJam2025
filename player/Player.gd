class_name Player
extends CharacterBody2D

@export var animation_player: AnimationPlayer
var SPEED: float = 150

func _process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	if velocity.length() > 1.0:
		animation_player.play("walk")
		rotation = rotate_toward(rotation, velocity.angle() + PI / 2, delta * 10)
	else:
		animation_player.play("RESET")

func _physics_process(delta: float) -> void:
	move_and_slide()
