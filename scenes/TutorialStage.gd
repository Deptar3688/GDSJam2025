extends Node2D

func _ready() -> void:
	%BackgroundStatic.visible = true
	%BackgroundStatic.modulate.a = 1
	%TutorialLabel.visible = true
	Global.player_has_moved_first_time.connect(start_game)

func start_game():
	create_tween().tween_property(%TutorialLabel, "modulate:a", 0, 1.0)