class_name DustParticle
extends Node2D

static var DustParticleScene: PackedScene = preload("res://scenes/DustParticle/DustParticle.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var velocity: Vector2 = Vector2.ZERO

func initialize() -> void:
	rotation = random_angle()
	animation_player.speed_scale = randf_range(0.5, 1.2)

func _process(delta: float) -> void:
	position += velocity * delta
	velocity = velocity.lerp(Vector2.ZERO, 3 * delta)

static func create(position: Vector2, parent: Node) -> DustParticle:
	var particle: DustParticle = DustParticleScene.instantiate()
	particle.position = position
	parent.add_child(particle)
	particle.initialize()
	return particle

static func create_dust_explosion(position: Vector2, num_particles: int, speed: float, parent: Node) -> void:
	for i in range(num_particles):
		var particle: DustParticle = create(position, parent)
		particle.z_index = 10
		particle.velocity = randf_range(0, speed) * random_direction()

## Returns a unit vector pointing in a random direction.
static func random_direction() -> Vector2:
	return Vector2.from_angle(random_angle())

## Returns a float representing a random angle, in radians.
static func random_angle() -> float:
	return randf_range(0, 2 * PI)
