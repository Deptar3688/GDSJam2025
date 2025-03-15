extends Area2D
class_name Letter

@onready var label = $RichTextLabel

@export var characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*1234567890'

var rotation_speed : float
var pos :Vector2 
var direction : Vector2
var velocity : float
var spread :float 

func _ready() ->void:
	Global.player_died.connect(queue_free)
	rotation_speed = randf_range(-2, 2)
	pos = (Global.player.global_position - global_position) 
	direction = (Global.player.global_position - global_position).normalized() 
	velocity = randf_range(30, 100)
	spread = randf_range(-PI/4, PI/4)
	
	
	direction = direction.rotated(spread)
	label.add_text(characters[randi()% characters.length()])
	
func _process(delta: float) -> void:
	rotation += rotation_speed*delta
	global_position += velocity * delta * direction 
	for body in get_overlapping_bodies():
		if body is Player:
			body.take_damage()
			DustParticle.create_dust_explosion(position, 25, 250, get_parent())
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
