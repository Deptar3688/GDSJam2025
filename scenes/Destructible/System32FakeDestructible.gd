extends "res://scenes/Destructible/Destructible.gd"

# Overrides the getting destroyed thing
func take_damage():
	AudioManager.play("res://audio/softThud.wav")
	current_health -= 1
	if current_health <= 0:
		$CollisionShape2D.disabled = true
		destroyed.emit()