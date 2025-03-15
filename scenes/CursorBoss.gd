extends Area2D

@export var HP: int = 40

@export var is_moving: bool = false:
	set(value):
		is_moving = value
		target_position = Vector2(randf_range(0, 400), randf_range(0, 300))

var target_position: Vector2

signal died()


func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	for area in get_overlapping_areas():
		if area is PlayerBullet:
			area.queue_free()
			take_damage()
	if is_moving and target_position.distance_to(position) > 5.0:
		position = position.move_toward(target_position, delta * 50)
	if target_position.distance_to(position) < 5.0:
		target_position = Vector2(randf_range(0, 400), randf_range(0, 300))

func take_damage():
	AudioManager.play("res://audio/softThud.wav")
	HP -= 1
	var t = modulate.r
	modulate.r = 100
	await get_tree().create_timer(0.05).timeout
	modulate.r = t
	if HP == 0:
		die()
		
func die():
	DustParticle.create_dust_explosion(position, 50, 600, get_parent())
	queue_free()
	died.emit()
