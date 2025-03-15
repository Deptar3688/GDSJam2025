extends Node2D

func _ready() -> void:
	%System32Destructible.destroyed.connect(cause_blue_screen)

func cause_blue_screen():
	pass