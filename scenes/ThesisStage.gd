extends Node2D


func _ready() -> void:
	%HUD.visible = false
	%ThesisDestructible.destroyed.connect(start_fr)

func start():
	%ThesisDestructible.disabled = false

func start_fr():
	%HUD.visible = true