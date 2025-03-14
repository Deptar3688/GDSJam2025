extends Area2D

@onready var texture = $TrashDoc/BG
@onready var texture_burning_material: ShaderMaterial = preload("res://scenes/StageSelection/StageIconBurningMaterial.tres")
var burnable : bool

func _ready() -> void:
	burnable = true

func burn():
	if burnable:
		burnable = false
		texture.material = texture_burning_material.duplicate(true)
		texture.material.get_shader_parameter("burn_texture").noise.seed = randi_range(-100000, 100000)
		create_tween().tween_property(texture, "material:shader_parameter/percentage", 0.0, 1.0)
