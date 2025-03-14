extends Area2D

@onready var texture = $TrashDoc/BG
@onready var texture_burning_material: ShaderMaterial = preload("res://scenes/StageSelection/StageIconBurningMaterial.tres")
@onready var SceneNode := get_tree().current_scene
var burnable : bool
@export var moving : bool

var speed : float

func _ready() -> void:
	burnable = true
	moving = false
	speed = 0.0
	
func _process(delta: float) -> void:
	# ---- CHECK IF PLAYER -----
	for body in get_overlapping_bodies():
		if body is Player and not SceneNode.full and SceneNode.spawning:
			SceneNode.full = true
			speed = 150.0
	
	var length :float = (Global.player.global_position - global_position).length()
	if length > 50:
		global_position += delta * (Global.player.global_position - global_position).normalized() * speed
	elif length < 45:
		global_position += delta * -(Global.player.global_position - global_position).normalized() * speed

func burn():
	if burnable:
		burnable = false
		texture.material = texture_burning_material.duplicate(true)
		texture.material.get_shader_parameter("burn_texture").noise.seed = randi_range(-100000, 100000)
		create_tween().tween_property(texture, "material:shader_parameter/percentage", 0.0, 1.0)
		SceneNode.full = false
