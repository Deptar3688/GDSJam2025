extends CanvasLayer

@onready var texture: TextureRect = $TextureRect

signal screen_covered()
signal transition_finished()

var static_tween: Tween

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


# Faster transitions
func start_transition2():
	if not visible:
		texture.material.set_shader_parameter("height", -0.01)
		visible = true
		await create_tween().tween_property(texture, "material:shader_parameter/height", 1.0, 0.5).finished
		screen_covered.emit()
		exit_transition2()

func exit_transition2():
	texture.material.set_shader_parameter("height", 0.01)
	visible = true
	await create_tween().tween_property(texture, "material:shader_parameter/height", -1.0, 0.5).finished
	transition_finished.emit()
	visible = false

func finish_game():
	visible = true
	var t: PropertyTweener = create_tween().tween_property($PixelSortOverlay, "material:shader_parameter/sort", 2.0, 4.0)
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await t.finished
	await get_tree().create_timer(2.0).timeout
	$AnimationPlayer.play("finish")

func transparent_static(duration: float, alpha: float):
	visible = true
	$OverlayStaticEffect.visible = true
	$OverlayStaticEffect.modulate.a = alpha
	await get_tree().create_timer(duration).timeout
	$OverlayStaticEffect.modulate.a = 0
	$OverlayStaticEffect.visible = false
	visible = false
