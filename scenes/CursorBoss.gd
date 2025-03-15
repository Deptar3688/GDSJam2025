extends Area2D

var HP: int = 40

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	for area in get_overlapping_areas():
		if area is PlayerBullet:
			area.queue_free()
			take_damage()

func take_damage():
	AudioManager.play("res://audio/softThud.wav")
	HP -= 1
	var t = modulate.r
	modulate.r = 100
	await get_tree().create_timer(0.05).timeout
	modulate.r = t
	if HP == 0:
		die()
		
func die():
	DustParticle.create_dust_explosion(position, 50, 600, get_parent())
	queue_free()
