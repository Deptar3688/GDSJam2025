extends Area2D

@export var spawn_time := 1.5
var current_spawn_time : float

@onready var FireHitPL := preload("res://scenes/FileDeletion/Enemies/FireHit.tscn")
var FireWallPL : PackedScene
var speed: float 
var direction : Vector2 
var FirePositions : Node2D
var shooting : bool
var shoot : bool

func _ready() -> void:
	FireWallPL = preload("res://scenes/FileDeletion/Enemies/FireWall.tscn")
	FirePositions = $FirePositions
	spawn_time = randf_range(1, 2)
	current_spawn_time = 0.0
	shoot = true
	Global.player_died.connect(queue_free)
	
func _process(delta: float) -> void:
	if not shooting:
		global_position += direction * speed * delta
	if (current_spawn_time >= spawn_time - 0.2 or current_spawn_time <= 0.2) and shoot:
		shooting = true
	else:
		shooting = false
		
	current_spawn_time += + delta
	if current_spawn_time >= spawn_time and shoot:
		AudioManager.play("res://audio/action.wav")
		shoot = false
		current_spawn_time = 0.0
		var proj_speed := randf_range(100, 250)
		for spot in FirePositions.get_children():
			var Fire := FireWallPL.instantiate()
			get_parent().add_child(Fire)
			Fire.speed = proj_speed
			Fire.global_position = global_position
			Fire.direction = spot.position.normalized()
			Fire.rotation = spot.position.angle() + 3 * (PI/2)
			
	# ----- CHECK IF HIT ----
	for body in get_overlapping_areas():
		if body is PlayerBullet:
			var FireHit := FireHitPL.instantiate()
			FireHit.global_position = global_position
			get_parent().add_child(FireHit)
			queue_free()

				

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
