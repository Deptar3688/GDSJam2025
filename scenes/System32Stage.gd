extends Node2D

func _ready() -> void:
	%System32FakeDestructible.destroyed.connect(start_cursor_fight)
	%System32Destructible.destroyed.connect(cause_blue_screen)

func activate_fake_destructible():
	%System32FakeDestructible.disabled = false

func start_cursor_fight():
	$AnimationPlayer.play("cursor_spawn")

func cause_blue_screen():
	AudioManager.play("res://audio/zapsplat_science_fiction_robot_glitch_processing_error_malfunction_112389.mp3")
	ScreenTransition.finish_game()

func play_cursor_descend_audio():
	AudioManager.play("res://audio/zapsplat_sound_design_lfe_rumble_whoosh_001_77610.mp3")
