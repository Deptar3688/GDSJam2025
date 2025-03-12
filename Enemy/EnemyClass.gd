class_name Enemy
extends Area2D


@export var SPEED := 20.0
@export var HEALTH := 10.0

func _process(delta: float) -> void:
	var player := get_tree().current_scene.find_child("Player", true, false)
	var direction = (player.global_position - global_position).normalized()
	
	global_position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		pass
