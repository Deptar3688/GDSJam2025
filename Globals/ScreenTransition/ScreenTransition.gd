extends CanvasLayer

@onready var texture: TextureRect = $TextureRect

signal screen_covered()
signal transition_finished()

func _ready() -> void:
	visible = false
	texture.material.set_shader_parameter("height", -1.0)

func start_transition():
	if not visible:
		texture.material.set_shader_parameter("height", -1.0)
		visible = true
		await create_tween().tween_property(texture, "material:shader_parameter/height", 1.0, 1.0).finished
		screen_covered.emit()
		exit_transition()

func exit_transition():
	texture.material.set_shader_parameter("height", 1.0)
	visible = true
	await create_tween().tween_property(texture, "material:shader_parameter/height", -1.0, 1.0).finished
	transition_finished.emit()
	visible = false