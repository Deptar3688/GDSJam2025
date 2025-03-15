extends Node2D

@export var skip_tutorial_debug: bool = false

var firewalls_left_to_destroy: int

func _ready() -> void:
	if skip_tutorial_debug:
		return
	%BackgroundStatic.visible = true
	%BackgroundStatic.modulate.a = 1
	%Background.modulate.a = 0
	%TutorialLabel.visible = true
	Global.player_has_moved_first_time.connect(start_game)
	%FirewallDestructibles.visible = true
	for firewall_destructible in %FirewallDestructibles.get_children():
		firewalls_left_to_destroy += 1
		firewall_destructible.destroyed.connect(firewall_destroyed)

func start_game():
	create_tween().tween_property(%TutorialLabel, "modulate:a", 0, 1.0)

func firewall_destroyed():
	firewalls_left_to_destroy -= 1
	if firewalls_left_to_destroy <= 0:
		await get_tree().create_timer(2.0).timeout
		await create_tween().tween_property(%Background, "modulate:a", 1, 5.0).finished
		$AnimationPlayer.play("hacked")
		await get_tree().create_timer(3.0).timeout
		%ThesisDestructible.disabled = false
