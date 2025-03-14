extends Node2D

@onready var trash = $Trash
@onready var trash_doc = $TrashDoc

@export var map_height := 4
@export var map_width := 4
var player_height := 2
var player_width := 2
var trash_height : int
var trash_width : int

func _ready() -> void:
	trash.visible = false
	
	trash_width = randi()%map_width
	trash_height = randi()%map_height
	if trash_height == 2 and trash_width==2:
		trash_height = 0
		trash_width = 0
	
	
func _process(delta: float) -> void:
	#print(player_height, player_width)
	# Check if player off screen and move accordingly
	var view := get_viewport_rect().size
	# if off screen on left
	if Global.player.global_position.x <= 0:
		newLocation()
		player_width -= 1
		if player_width < 0:
			player_width = map_width
		Global.player.global_position = Vector2(view.x, Global.player.global_position.y)
		trash_doc.global_position = Vector2(view.x, Global.player.global_position.y)
	# Off screen on right
	elif Global.player.global_position.x >= view.x :
		newLocation()
		player_width += 1
		if player_width > map_width:
			player_width = 0
		Global.player.global_position = Vector2(0, Global.player.global_position.y)
		trash_doc.global_position = Vector2(0, Global.player.global_position.y)
	# Off screen top
	elif Global.player.global_position.y <= 0:
		newLocation()
		player_height -= 1
		if player_height < 0:
			player_height = map_height
		Global.player.global_position = Vector2(Global.player.global_position.x, view.y)
		trash_doc.global_position =  Vector2(Global.player.global_position.x, view.y)
	# Off screen bottom
	elif Global.player.global_position.y >= view.y :
		newLocation()
		player_height += 1
		if player_height > map_height:
			player_height = 0
		Global.player.global_position = Vector2(Global.player.global_position.x, 0)
		trash_doc.global_position = Vector2(Global.player.global_position.x, 0)
	if trash_doc != null:
		var length : float = (Global.player.global_position - trash_doc.global_position).length()
		if length > 50:
			trash_doc.global_position += delta * (Global.player.global_position - trash_doc.global_position).normalized() * 150
		elif length < 45:
			trash_doc.global_position += delta * -(Global.player.global_position - trash_doc.global_position).normalized() * 150
			
func newLocation() -> void:
	print(trash_height, trash_width)
	ScreenTransition.start_transition2()
	if player_height == trash_height and player_width ==trash_width:
		trash.visible = true
	else:
		trash.visible = false
