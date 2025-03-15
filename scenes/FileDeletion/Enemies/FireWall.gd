extends Area2D

@onready var FireHitPL := preload("res://scenes/FileDeletion/Enemies/FireHit.tscn")

@export var speed := 50.0
var direction : Vector2

func _ready() -> void:
	Global.player_died.connect(queue_free)

func _process(delta: float) -> void:
	global_position += direction * delta * speed
	for body in get_overlapping_bodies():
		if body is Player:
			body.take_damage()
			var FireHit := FireHitPL.instantiate()
			FireHit.global_position = Global.player.global_position
			get_parent().add_child(FireHit)
			queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
