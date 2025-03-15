class_name PlayerBullet
extends Area2D

var SPEED:= 300
var direction: Vector2

func _process(delta):
	global_position += direction*SPEED*delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
