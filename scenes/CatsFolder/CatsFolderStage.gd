extends Node2D

@export var cat_enemies: Array[PackedScene]
@export var spawning: bool = false

var spawn_timer: float = 1.0
var current_spawn_time: float

func _ready() -> void:
	current_spawn_time = spawn_timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawning:
		current_spawn_time -= delta
		if current_spawn_time <= 0:
			current_spawn_time = spawn_timer
			spawn_enemy()

func spawn_enemy():
	var screen_size = get_viewport_rect().size
	var edge = randi() % 4  # Pick a random edge
	var spawn_position: Vector2
	match edge:
		0:  # Top
			spawn_position = Vector2(randf_range(0, screen_size.x), -80)
		1:  # Bottom
			spawn_position = Vector2(randf_range(0, screen_size.x), screen_size.y + 80)
		2:  # Left
			spawn_position = Vector2(-80, randf_range(0, screen_size.y))
		3:  # Right
			spawn_position = Vector2(screen_size.x + 80, randf_range(0, screen_size.y))

	var enemy: CatEnemy = cat_enemies.pick_random().instantiate()
	enemy.position = spawn_position
	add_child(enemy)
