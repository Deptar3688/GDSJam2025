extends Node2D

func _ready() -> void:
	%System32FakeDestructible.destroyed.connect(start_cursor_fight)
	%System32Destructible.destroyed.connect(cause_blue_screen)

func start_cursor_fight():
	pass # TODO: The cursor drags it away

func cause_blue_screen():
	ScreenTransition.finish_game()
