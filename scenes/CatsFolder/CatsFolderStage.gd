extends Node2D

@export var cat_enemies: Array[PackedScene]
@export var is_active: bool = false

var spawn_timer: float = 1.0
var current_spawn_time: float

var survive_timer: float = 30.0

func _ready() -> void:
	current_spawn_time = spawn_timer
	%CatPicturesDestructible.destroyed.connect(func(): %AnimationPlayer.play("start_cat_stage"))

func start():
	%HUD.set_text("Level 3: cat pictures")
	is_active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		survive_timer -= delta
		current_spawn_time -= delta
		if current_spawn_time <= 0:
			current_spawn_time = spawn_timer
			spawn_enemy()
		if survive_timer <= 0:
			is_active = false
			for node in get_children():
				if node is CatEnemy:
					node.queue_free()
					DustParticle.create_dust_explosion(node.position, 4, 300, get_parent())

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
