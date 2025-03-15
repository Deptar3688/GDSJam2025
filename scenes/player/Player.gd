class_name Player
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var MAX_HEALTH: int = 5
var SPEED: float = 150
var TRAIL_LENGTH: int = 16

var current_health: int:
	set(value):
		current_health = max(0, value)

var prev_positions: Array[Vector2]

func _ready() -> void:
	current_health = MAX_HEALTH
	Global.player = self

func _process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if not Global.player_has_moved and direction != Vector2.ZERO:
		Global.player_has_moved_first_time.emit()
		Global.player_has_moved = true
	velocity = direction * SPEED
	if velocity.length() > 1.0:
		animation_player.play("walk")
		sprite.rotation = rotate_toward(sprite.rotation, velocity.angle() + PI / 2, delta * 10)
	else:
		animation_player.play("RESET")
	queue_redraw()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		ScreenTransition.start_transition()

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

func take_damage():
	current_health -= 1
	Global.player_damaged.emit(current_health)
	AudioManager.play("res://audio/softDestroy.wav")
	AudioManager.play("res://audio/zapsplat_science_fiction_robot_glitch_error_malfunction_short_112386.mp3")
	if current_health <= 0:
		AudioManager.play("res://audio/zapsplat_science_fiction_robot_glitch_processing_error_malfunction_112389.mp3")
		ScreenTransition.transparent_static(2.0, 1.0)
	else:
		ScreenTransition.transparent_static(0.2, 0.4)
