extends Area2D

func _process(delta: float) -> void:
	if visible:
		for body in get_overlapping_areas():
			if body.is_in_group("Trashable"):
				body.queue_free()
