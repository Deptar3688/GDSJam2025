extends Node2D

@export var cat_enemies: Array[PackedScene]
@export var is_active: bool = false

var ORIGINAL_SPAWN_TIMER: float = 1.2
var RAMPING_SPAWN_TIMER: float = 0.5

var spawn_timer: float = 1.2
var current_spawn_time: float

var total_timer: float = 0.0

func _ready() -> void:
	current_spawn_time = spawn_timer
	%CatPicturesDestructible.destroyed.connect(func(): %AnimationPlayer.play("start_cat_stage"))
	Global.player_died.connect(_on_player_death)

func _on_player_death():
	if not is_active:
		return
	%CatPicturesDestructible.disabled = false
	%CatPicturesDestructible.current_health = 5
	is_active = false
	$Audio.stop()
	total_timer = 0.0

func start():
	spawn_timer = ORIGINAL_SPAWN_TIMER
	%HUD.set_text("Level 3: cat pictures")
	is_active = true
	$Audio.play()

func play_cinematic_sound():
	AudioManager.play("res://audio/morphed-metal-discharged-cinematic-trailer-sound-effects-124763.mp3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		current_spawn_time -= delta
		if current_spawn_time <= 0:
			current_spawn_time = spawn_timer
			spawn_enemy()
		total_timer += delta
		if total_timer >= 11.0:
			spawn_timer = RAMPING_SPAWN_TIMER
		if total_timer >= 25.7:
			deactivate()
			
func deactivate():
	is_active = false
	for node in get_children():
		if node is CatEnemy:
			node.queue_free()
			DustParticle.create_dust_explosion(node.position, 4, 300, get_parent())
	await get_tree().create_timer(3.0).timeout
	%System32Stage.activate_fake_destructible()

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
