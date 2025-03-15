class_name FirewallAttack
extends Area2D

var direction: Vector2
var SPEED := 100

@onready var FireHitPL := preload("res://scenes/FileDeletion/Enemies/FireHit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2(-1, 0)
	Global.player_died.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction*SPEED*delta
	
	for body in get_overlapping_bodies():
			if body is Player:
				body.take_damage()
				var FireHit := FireHitPL.instantiate()
				FireHit.global_position = Global.player.global_position
				get_parent().add_child(FireHit)
				queue_free()
