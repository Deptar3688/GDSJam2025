extends Area2D

@onready var letterPL := preload("res://scenes/ThesisFolder/Enemy/Letters/Letter.tscn")

@export var shoot_time := 1.0
@export var amount := 5
@export var speed := 50.0
@export var active := false

@export var HEALTH := 50
var current_health : int

var current_time : float
var distance : Vector2
var length : float
var pos : Vector2
signal die

var player_direction : Vector2
@onready var leaving_timer : Timer = $LeavingTimer
@onready var move_duration : Timer = $MoveDuration
var leaving := false
var just_active := false


func _ready() -> void:
	current_time = shoot_time
	current_health = HEALTH
	
func _process(delta: float) -> void:
	if active:
		if just_active:	
			just_active = true
			leaving_timer.start()
		distance = Global.player.global_position - global_position
		length = distance.length()
		player_direction = distance.normalized()
		
		
		var view := get_viewport_rect().size
		# if off screen on left
		if global_position.x <= -30:
			global_position.x = view.x
			leaving = false
		# Off screen on right
		elif global_position.x >= view.x + 30:
			global_position.x = 0
			leaving = false
		# Off screen top
		elif global_position.y <= -30:
			global_position.y = view.y
			leaving = false
		# Off screen bottom
		elif global_position.y >= view.y + 30:
			global_position.y = 0
			leaving = false
		else:
			if length <= 200 or leaving:
				pos = (Global.player.global_position - global_position)
				global_position +=  -pos.normalized() * speed * delta
			else:
				pos = (Global.player.global_position - global_position)
				global_position +=  pos.normalized() * speed * delta
			
		if current_time <= 0:
			current_time = shoot_time
			shoot()
		current_time -= delta
		
		for body in get_overlapping_areas():
			if body is PlayerBullet:
				damage()
				body.queue_free()

func damage() -> void:
	current_health -= 1
	DustParticle.create_dust_explosion(position, 8, 300, get_parent())
	var original = modulate
	modulate = Color(100,100,100)
	await get_tree().create_timer(0.05).timeout
	modulate = original
	if current_health < 0 : 
		DustParticle.create_dust_explosion(position, 50, 600, get_parent())
		emit_signal("die")
		queue_free()
	elif current_health <= 20 and current_health%5 == 0:
		amount +=1

func shoot() -> void:
	for i in range(amount):
		var letter = letterPL.instantiate()
		letter.global_position = global_position
		get_tree().current_scene.add_child(letter)

func _on_leaving_timer_timeout():
	leaving = true
	move_duration.start()


func _on_move_duration_timeout():
	leaving = false
	leaving_timer.start()
