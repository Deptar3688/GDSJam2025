extends Area2D

@export var SPEED := 50.0
var direction := Vector2(1,0)

func _process(delta: float) -> void:
	global_position += direction * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
