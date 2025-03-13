extends Area2D
class_name Letter

@onready var label = $RichTextLabel

@export var characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

var rotation_speed := randf_range(-2, 2)
var pos :Vector2 = (Global.player.global_position - global_position) 
var dir = pos/pos.abs()
var direction := (Global.player.global_position - global_position).normalized()
var velocity := randf_range(30, 100)

func _ready() ->void:
	label.add_text(characters[randi()% characters.length()])
	
func _process(delta: float) -> void:
	rotation += rotation_speed*delta
	global_position += velocity * delta * direction * dir
	for body in get_overlapping_bodies():
		if body is Player:
			body.take_damage()
			DustParticle.create_dust_explosion(position, 25, 250, get_parent())
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
