extends Node2D

@onready var anim := $AnimationPlayer

@export var start : bool

@export var spawning := false
@export var spawn_time := 0.5
var current_spawn_time : float

func _ready() -> void:
	current_spawn_time = spawn_time
	start = false
	%HUD.visible = false
	%ThesisDestructible.destroyed.connect(func(): 
		start = true
		%HUD.visible = true
		)
	
func _process(delta: float) -> void:
	if start:
		anim.play("start")
		start = false
	
	if spawning:
		current_spawn_time -= delta
		if current_spawn_time <= 0:
			current_spawn_time = spawn_time
			

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'end':
		get_parent().FileDeleteStage.disabled = false


func _on_word_enemy_die():
	create_tween().tween_property($Window, "material:shader_parameter/percentage", 0.0, 1.0)
	await get_tree().create_timer(4).timeout
	anim.play("end")
