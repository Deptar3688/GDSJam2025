extends Area2D
class_name Trash

@onready var texture_burning_material: ShaderMaterial = preload("res://scenes/StageSelection/StageIconBurningMaterial.tres")
@onready var SceneNode := get_parent()
var texture : TextureRect
var spawned :bool

func _ready() -> void:
	visible = false
	spawned = false

func spawn()->void:
	if not spawned :
		DustParticle.create_dust_explosion(position, 16, 300, get_parent())

func poof() -> void:
	visible = false
	DustParticle.create_dust_explosion(position, 16, 300, get_parent())

func _process(delta: float) -> void:
	if visible and SceneNode.spawning:
		for body in get_overlapping_areas():
			if body.is_in_group("Trashable"):
				body.burn()
