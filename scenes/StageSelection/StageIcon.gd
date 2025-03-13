extends Control

@onready var texture: TextureRect = $TextureRect
@onready var text_label: RichTextLabel = $RichTextLabel
@onready var texture_burning_material: ShaderMaterial = preload("res://scenes/StageSelection/StageIconBurningMaterial.tres")

var is_hovered: bool = false:
	set(value):
		is_hovered = value
		if is_hovered:
			texture.material.set_shader_parameter("shake_rate", 1.0)
		else:
			texture.material.set_shader_parameter("shake_rate", 0)
			
var is_burning: bool = false

func _ready() -> void:
	texture.material.set_shader_parameter("shake_rate", 0)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta: float) -> void:
	if is_hovered and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not is_burning:
		burn()

func _on_mouse_entered():
	is_hovered = true

func _on_mouse_exited():
	is_hovered = false

func burn():
	is_burning = true
	texture.material = texture_burning_material.duplicate(true)
	texture.material.get_shader_parameter("burn_texture").noise.seed = randi_range(-100000, 100000)
	create_tween().tween_property(texture, "material:shader_parameter/percentage", 0.0, 1.0)
	text_label.material = texture_burning_material.duplicate(true)
	text_label.material.get_shader_parameter("burn_texture").noise.seed = randi_range(-100000, 100000)
	create_tween().tween_property(text_label, "material:shader_parameter/percentage", 0.0, 1.0)
