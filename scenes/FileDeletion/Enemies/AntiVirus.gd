extends Area2D

@export var spawn_time := 1.0
var current_spawn_time : float

var FireWallPL : PackedScene
var speed: float 
var direction : Vector2 
var FirePositions : Node2D

func _ready() -> void:
	FireWallPL = preload("res://scenes/FileDeletion/Enemies/FireWall.tscn")
	FirePositions = $FirePositions
	current_spawn_time = 0.0
	
func _process(delta: float) -> void:
		global_position += direction * speed * delta
		
		current_spawn_time += + delta
		if current_spawn_time >= spawn_time:
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
