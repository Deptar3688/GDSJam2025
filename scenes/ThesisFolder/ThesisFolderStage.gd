extends Node2D

@export var spawning := false
@export var spawn_time := 0.5
var current_spawn_time : float

func _ready() -> void:
	current_spawn_time = spawn_time
	
func _process(delta: float) -> void:
	if spawning:
		current_spawn_time -= delta
		if current_spawn_time <= 0:
			current_spawn_time = spawn_time
			
