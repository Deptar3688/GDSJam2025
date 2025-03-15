extends Area2D

@export var current_health := 5
@export var disabled = false:
	set(value):
		disabled = value
		if disabled:
			$CollisionShape2D.disabled = true
			visible = false
		else:
			$CollisionShape2D.disabled = false
			visible = true
			DustParticle.create_dust_explosion(position, 16, 300, get_parent())

signal destroyed()

func _ready() -> void:
	visible = false
	if not disabled:
		visible = true
		$CollisionShape2D.disabled = false

func _process(delta: float) -> void:
	for area in get_overlapping_areas():
		if area is PlayerBullet:
			take_damage()
			DustParticle.create_dust_explosion(area.position, 8, 250, get_parent())
			area.queue_free()

func take_damage():
	current_health -= 1
	if current_health <= 0:
		destroyed.emit()
		disabled = true
		DustParticle.create_dust_explosion(position, 16, 300, get_parent())
