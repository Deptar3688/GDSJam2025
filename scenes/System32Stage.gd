extends Node2D

@export var is_active: bool = false

@onready var firewall_container: =$FirewallContainer
@export var firewall_flame: PackedScene
@onready var attack_timer : Timer = $AttackTimer
var fire_columns := 0
var start_fight := false
enum phase {FIREWALL, MINESWEEPER}
var is_attacking:= false
var current_phase: phase

@onready var mine_container: =$MineContainer
@export var mine_scene: PackedScene

var in_a_row := 0

func _ready() -> void:
	%System32FakeDestructible.destroyed.connect(start_cursor_fight)
	%System32Destructible.destroyed.connect(cause_blue_screen)
	$CursorBoss.died.connect(func(): 
		start_fight = false
		is_attacking = false
		attack_timer.stop()
		await get_tree().create_timer(3.0).timeout
		%System32Destructible.disabled = false
		)
	Global.player_died.connect(_on_player_died)

func _on_player_died():
	if not is_active:
		return
	if $CursorBoss.is_moving:
		return

	%System32FakeDestructible.disabled = false
	%System32FakeDestructible.current_health = 5
	is_active = false
	start_fight = false
	is_attacking = false
	attack_timer.stop()

func activate_fake_destructible():
	%System32FakeDestructible.disabled = false

func start_cursor_fight():
	is_active = true
	$AnimationPlayer.play("cursor_spawn")
	
	await get_tree().create_timer(7).timeout
	start_fight = true
	current_phase = phase.values().pick_random()
	attack_timer.start()
	$CursorBoss.is_moving = true

func cause_blue_screen():
	AudioManager.play("res://audio/zapsplat_science_fiction_robot_glitch_processing_error_malfunction_112389.mp3")
	ScreenTransition.finish_game()

func spawn_firewall():
	var screen_size = get_viewport_rect().size
	var firewall_amount = screen_size.y / 28
	var spawn_position: Vector2
	
	var flame: Area2D
	for j in range(5):
		var t_fireballs = []
		for i in firewall_amount:
			flame = firewall_flame.instantiate()
			spawn_position = Vector2(screen_size.x + 80, 30 * i) # spawn from right side in a column
			flame.global_position = spawn_position
			firewall_container.add_child(flame)
			t_fireballs.append(flame)
			
		firewall_container.remove_child(t_fireballs.pick_random())
		
		await get_tree().create_timer(1.5).timeout

func minesweeper_attack():
	var mine = Area2D
	for j in range(3):
		for i in range(10):
			mine = mine_scene.instantiate()
			mine.global_position = Vector2i(randi_range(50, 350), randi_range(50, 250))
			mine_container.add_child(mine)
		await get_tree().create_timer(4).timeout

func _process(delta):
	if is_active:
		if start_fight:
			if current_phase == phase.FIREWALL and not is_attacking:
				is_attacking = true
				spawn_firewall()
			
			elif current_phase == phase.MINESWEEPER and not is_attacking:
				is_attacking = true
				minesweeper_attack()
	
func play_cursor_descend_audio():
	AudioManager.play("res://audio/zapsplat_sound_design_lfe_rumble_whoosh_001_77610.mp3")


func _on_attack_timer_timeout():
	var prev_phase = current_phase
	current_phase = phase.values().pick_random()
	if current_phase == prev_phase:
		in_a_row+=1
	else:
		in_a_row = 0
	
	if in_a_row == 3:
		while current_phase == prev_phase:
			current_phase = phase.values().pick_random()
		in_a_row = 0
	
	is_attacking = false
	
	
