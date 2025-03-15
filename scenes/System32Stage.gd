extends Node2D

@onready var firewall_container: =$FirewallContainer
@export var firewall_flame: PackedScene

func _ready() -> void:
	%System32FakeDestructible.destroyed.connect(start_cursor_fight)
	%System32Destructible.destroyed.connect(cause_blue_screen)

func activate_fake_destructible():
	%System32FakeDestructible.disabled = false

func start_cursor_fight():
	$AnimationPlayer.play("cursor_spawn")

func cause_blue_screen():
	AudioManager.play("res://audio/zapsplat_science_fiction_robot_glitch_processing_error_malfunction_112389.mp3")
	ScreenTransition.finish_game()

<<<<<<< HEAD
func spawn_firewall():
	var screen_size = get_viewport_rect().size
	var firewall_amount = screen_size / 21
	var spawn_position: Vector2
	
	var flame = firewall_flame.instantiate()
	
	for i in firewall_amount:
		spawn_position = Vector2(screen_size.x + 80, 14 * i) # spawn from right side in a column
		firewall_container.add_child(flame)
	
func _process(delta):
	pass
=======
func play_cursor_descend_audio():
	AudioManager.play("res://audio/zapsplat_sound_design_lfe_rumble_whoosh_001_77610.mp3")
>>>>>>> 2ee3ad832ec836ef4cd39073b8e4b4d124f0e517
