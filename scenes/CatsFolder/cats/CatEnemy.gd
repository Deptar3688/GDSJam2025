class_name CatEnemy
extends Area2D

var rotation_speed: float
var direction: Vector2
var speed: float
var time: float = 0.0
var wavy_amplitude: float

enum CatType {NORMAL, HOMING, WAVY}
var type: int

@onready var sprite: Node2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	direction = (Global.player.position - position).normalized()
	type = CatType.values().pick_random()
	Global.player_died.connect(queue_free)
	match type:
		CatType.NORMAL:
			rotation_speed = randf_range(5, 10)
			if randf() < 0.5:
				rotation_speed *= -1
			speed = randf_range(30.0, 200.0)
		CatType.HOMING:
			rotation_speed = randf_range(10, 20)
			if randf() < 0.5:
				rotation_speed *= -1
			speed = randf_range(50.0, 100.0)
		CatType.WAVY:
			rotation_speed = randf_range(5, 10)
			if randf() < 0.5:
				rotation_speed *= -1
			speed = randf_range(30.0, 100.0)
			wavy_amplitude = randf_range(50, 200)

func _process(delta: float) -> void:
	time += delta

	sprite.rotation += rotation_speed * delta
	collision.rotation += rotation_speed * delta

	rotation_speed = lerpf(rotation_speed, 0, 0.5 * delta)
	for body in get_overlapping_bodies():
		if body is Player:
			body.take_damage()
			DustParticle.create_dust_explosion(position, 25, 250, get_parent())
			queue_free()
	if type == CatType.WAVY:
		time += delta * 5 # Controls wave frequency; adjust as needed
		var perpendicular = Vector2(-direction.y, direction.x) # Get perpendicular direction
		var wave_offset = perpendicular * sin(time) * wavy_amplitude # Adjust amplitude as needed
		position += (direction * speed + wave_offset) * delta
	else:
		position += direction * speed * delta
	if type == CatType.HOMING:
		direction = Vector2.from_angle(lerp_angle(direction.angle(), (Global.player.position - position).angle(), 2 * delta))
		if (Global.player.position - position).length() < 80:
			type = CatType.NORMAL
	if position.x < -100 or position.x > get_viewport_rect().size.x + 100 \
	or position.y < -100 or position.y > get_viewport_rect().size.y + 100:
		queue_free()
