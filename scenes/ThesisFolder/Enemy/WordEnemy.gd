extends Area2D

@onready var letterPL := preload("res://scenes/ThesisFolder/Enemy/Letters/Letter.tscn")

@export var shoot_time := 0.5
var current_time : float

func _ready() -> void:
	current_time = shoot_time
	
func _process(delta: float) -> void:
	if current_time <= 0:
		current_time = shoot_time
		shoot()
	current_time -= delta
	
func shoot() -> void:
	var letter = letterPL.instantiate()
	letter.global_position = global_position
	get_tree().current_scene.add_child(letter)
	
