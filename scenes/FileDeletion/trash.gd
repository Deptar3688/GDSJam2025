extends Area2D

@onready var texture_burning_material: ShaderMaterial = preload("res://scenes/StageSelection/StageIconBurningMaterial.tres")
@onready var SceneNode := get_tree().current_scene
var texture : TextureRect

func _process(delta: float) -> void:
	if visible and  SceneNode.spawning:
		for body in get_overlapping_areas():
			if body.is_in_group("Trashable"):
				body.burn()
