extends Node2D

@onready var anim := $AnimationPlayer

@export var start : bool

@export var spawning := false
@export var spawn_time := 0.5
var current_spawn_time : float

var is_active: bool = false

func _ready() -> void:
	current_spawn_time = spawn_time
	start = false
	%HUD.visible = false
	%ThesisDestructible.destroyed.connect(func(): 
		start = true
		%HUD.visible = true
		)
	Global.player_died.connect(_on_player_death)
	$WordEnemy.die.connect(_on_word_enemy_die)

func _on_player_death():
	if not is_active:
		return
	anim.play("RESET")
	%ThesisDestructible.disabled = false
	%ThesisDestructible.current_health = 5

func _process(delta: float) -> void:
	if start:
		anim.play("start")
		start = false
		is_active = true
	
	if spawning:
		current_spawn_time -= delta
		if current_spawn_time <= 0:
			current_spawn_time = spawn_time

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'end':
		get_parent().FileDeleteStage.disabled = false
		is_active = false


func _on_word_enemy_die():
	AudioManager.play("res://audio/fire-sound-effects-224089.wav")			
	create_tween().tween_property($Window, "material:shader_parameter/percentage", 0.0, 1.0)
	await get_tree().create_timer(1).timeout
	anim.play("end")
