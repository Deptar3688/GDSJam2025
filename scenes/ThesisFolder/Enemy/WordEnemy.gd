extends Area2D

@onready var letterPL := preload("res://scenes/ThesisFolder/Enemy/Letters/Letter.tscn")

@export var shoot_time := 1.0
@export var amount := 5
@export var speed := 50.0
var current_time : float
var distance : Vector2
var length : float
var pos : Vector2

func _ready() -> void:
	current_time = shoot_time
	
func _process(delta: float) -> void:
	distance = Global.player.global_position - global_position
	length = distance.length()
		
	var view := get_viewport_rect().size
	# if off screen on left
	if global_position.x <= -30:
		global_position.x = view.x
	# Off screen on right
	elif global_position.x >= view.x + 30:
		global_position.x = 0
	# Off screen top
	elif global_position.y <= -30:
		global_position.y = view.y
	# Off screen bottom
	elif global_position.y >= view.y + 30:
		global_position.y = 0
	else:
		if length <= 200:
			pos = (Global.player.global_position - global_position)
			global_position +=  -pos.normalized() * speed * delta
		else:
			pos = (Global.player.global_position - global_position)
			global_position +=  pos.normalized() * speed * delta
		
	if current_time <= 0:
		current_time = shoot_time
		shoot()
	current_time -= delta
	
	
	
func shoot() -> void:
	for i in range(amount):
		var letter = letterPL.instantiate()
		letter.global_position = global_position
		get_tree().current_scene.add_child(letter)
	
