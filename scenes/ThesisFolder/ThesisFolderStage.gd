extends Node2D

@onready var anim := $AnimationPlayer

@export var start : bool

@export var spawning := false
@export var spawn_time := 0.5
var current_spawn_time : float

func _ready() -> void:
	current_spawn_time = spawn_time
	start = false
	
func _process(delta: float) -> void:
	if start:
		anim.play("start")
		start = false
	
	if spawning:
		current_spawn_time -= delta
		if current_spawn_time <= 0:
			current_spawn_time = spawn_time
			
