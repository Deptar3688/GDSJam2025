class_name CatEnemy
extends Area2D

var rotation_speed: float
var direction: Vector2
var speed: float

func _ready() -> void:
	rotation_speed = randf_range(-2, 2)
	direction = (Global.player.position - position).normalized()
	speed = randf_range(5.0, 200.0)

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	for body in get_overlapping_bodies():
		if body is Player:
			body.take_damage()
			DustParticle.create_dust_explosion(position, 25, 250, get_parent())
			queue_free()
	position += direction * speed * delta
	if position.x < -100 or position.x > get_viewport_rect().size.x + 100 \
	or position.y < -100 or position.y > get_viewport_rect().size.y + 100:
		queue_free()
