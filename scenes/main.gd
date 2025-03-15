extends Node2D

@onready var player:= $Player 
@onready var player_bullet_node:= $PlayerBullets
@export var player_bullet_tscn: PackedScene
@onready var shoot_cooldown:= $Player/ShootCD
@onready var FileDeleteStage := %FileDeleteStage
@onready var CatPictureDestruc := %CatPicturesDestructible

func _ready():
	pass


func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and shoot_cooldown.is_stopped():
		var player_bullet = player_bullet_tscn.instantiate()
		player_bullet.global_position = player.global_position
		player_bullet.direction = (get_global_mouse_position() - player.global_position).normalized()
		player_bullet_node.add_child(player_bullet)
		shoot_cooldown.start()
	
