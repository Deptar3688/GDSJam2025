extends Node2D

var score: int
@onready var enemy: Sprite2D = $McAfee
@onready var player: CharacterBody2D = $PlayerTest
var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = (player.global_position - enemy.global_position).normalized()
	enemy.global_position += direction
	pass


func _on_pc_body_entered(body: Node2D) -> void:
	print(body)
	score += 1
	print(score)
	pass # Replace with function body.
