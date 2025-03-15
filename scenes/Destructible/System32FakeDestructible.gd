extends "res://scenes/Destructible/Destructible.gd"

# Overrides the getting destroyed thing
func take_damage():
	current_health -= 1
	if current_health <= 0:
		$CollisionShape2D.disabled = true
		# TODO: play dragged away animation
		destroyed.emit()