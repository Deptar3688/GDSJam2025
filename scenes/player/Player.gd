class_name Player
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var SPEED: float = 150
var TRAIL_LENGTH: int = 16

var prev_positions: Array[Vector2]

func _process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	if velocity.length() > 1.0:
		animation_player.play("walk")
		sprite.rotation = rotate_toward(sprite.rotation, velocity.angle() + PI / 2, delta * 10)
	else:
		animation_player.play("RESET")
	queue_redraw()

func _physics_process(delta: float) -> void:
	prev_positions.append(position)
	if prev_positions.size() > TRAIL_LENGTH: prev_positions.pop_front()
	move_and_slide()

func _draw() -> void:
	var prev_positions_local: Array = prev_positions.map(func(prev_pos: Vector2): return prev_pos - position)
	var c = 1
	for prev_pos: Vector2 in prev_positions_local:
		draw_circle(prev_pos, c / float(TRAIL_LENGTH) * 2, Color(0.3, 1, 0.8, c / float(TRAIL_LENGTH)))
		c += 1
