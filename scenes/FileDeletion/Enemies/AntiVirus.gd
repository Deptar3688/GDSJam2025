extends Area2D

@export var spawn_time := 1.5
var current_spawn_time : float

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
	
func _process(delta: float) -> void:
	if not shooting:
		global_position += direction * speed * delta
	if (current_spawn_time >= spawn_time - 0.15 or current_spawn_time <= 0.15) and shoot:
		shooting = true
	else:
		shooting = false
		
	current_spawn_time += + delta
	if current_spawn_time >= spawn_time and shoot:
		shoot = false
		current_spawn_time = 0.0
		var proj_speed := randf_range(100, 250)
		for spot in FirePositions.get_children():
			var Fire := FireWallPL.instantiate()
			get_tree().current_scene.EnemyNode.add_child(Fire)
			Fire.speed = proj_speed
			Fire.global_position = global_position
			Fire.direction = spot.position.normalized()
			Fire.rotation = spot.position.angle() + 3 * (PI/2)
				

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
