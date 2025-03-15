extends CanvasLayer

@onready var health_pips_container: Control = %HealthPipsContainer
var health_pips: Array[Control]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for pip in health_pips_container.get_children():
		health_pips.append(pip)
	Global.player_damaged.connect(_on_player_damaged)
	Global.player_died.connect(reset_health)

func _on_player_damaged(new_health: int):
	health_pips[new_health].visible = false
	DustParticle.create_dust_explosion(health_pips[new_health].global_position + Vector2(5, 5), 10, 100.0, self)

func reset_health():
	for pip in health_pips:
		pip.visible = true

func set_text(text: String):
	$RichTextLabel.text = text
