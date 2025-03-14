extends Node2D

@onready var trash = $Trash
@onready var trash_doc = $TrashDoc
@onready var AntiVirusPL := preload("res://scenes/FileDeletion/Enemies/AntiVirus.tscn")
@onready var FilePL := preload("res://scenes/FileDeletion/TrashDoc.tscn")
@onready var EnemyNode := $Enemies
@onready var FileNode := $Files
@onready var bg := $BG

#var map_height := 4
#var map_width := 4
#var player_height := 2
#var player_width := 2
#var trash_height : int
#var trash_width : int

@export var numFiles : float

@export var spawning : bool = false
var spawn_time := 0.5
var current_spawn_time : float
var full : bool
#var time_out:= 45.0
#var current_time : float

func _ready() -> void:
	current_spawn_time = 0.0
	full = false
	#current_time = 0.0
	
	# ------ INITALIZE NUMBER OF FILES ----------
	numFiles = 3
	
	# ------ ADD THE NUMBER OF FILES TO THE SCENE -------
	for i in range(numFiles):
		var trash_doc := FilePL.instantiate()
		FileNode.add_child(trash_doc)
		var temp := 0
		var spawn_pos =Vector2(randf_range(0, 400), randf_range(0,300))
		
		trash_doc.global_position = spawn_pos
	
	
	#trash_width = randi()%map_width
	#trash_height = randi()%map_height
	#if trash_height == 2 and trash_width==2:
		#trash_height = 0
		#trash_width = 0
	
	
func _process(delta: float) -> void:
	# ------ INCREMENT TIMER -------
	current_spawn_time += delta 
	#current_time += delta
	
	# --------- IF TIME IS UP SPAWN ENEMY -----------
	if current_spawn_time >= spawn_time and spawning:
		current_spawn_time = 0
		spawn_enemy()
	
	# --------- CHECK IF ANY MORE DOC ---------
	checkFiles()
	
	
	# Check if player off screen and move accordingly
	#var view := get_viewport_rect().size
	## if off screen on left
	#if Global.player.global_position.x <= 0 and $SurviveText.visible == false:
		#newLocation()
		#player_width -= 1
		#if player_width < 0:
			#player_width = map_width
		#Global.player.global_position = Vector2(view.x, Global.player.global_position.y)
		#if trash_doc != null:
			#trash_doc.global_position = Vector2(view.x, Global.player.global_position.y)
	## Off screen on right
	#elif Global.player.global_position.x >= view.x and $SurviveText.visible == false:
		#newLocation()
		#player_width += 1
		#if player_width > map_width:
			#player_width = 0
		#Global.player.global_position = Vector2(0, Global.player.global_position.y)
		#if trash_doc != null:
			#trash_doc.global_position = Vector2(0, Global.player.global_position.y)
	## Off screen top
	#elif Global.player.global_position.y <= 0 and $SurviveText.visible == false:
		#newLocation()
		#player_height -= 1
		#if player_height < 0:
			#player_height = map_height
		#Global.player.global_position = Vector2(Global.player.global_position.x, view.y)
		#if trash_doc != null:
			#trash_doc.global_position =  Vector2(Global.player.global_position.x, view.y)
	## Off screen bottom
	#elif Global.player.global_position.y >= view.y and $SurviveText.visible == false:
		#newLocation()
		#player_height += 1
		#if player_height > map_height:
			#player_height = 0
		#Global.player.global_position = Vector2(Global.player.global_position.x, 0)
		#if trash_doc != null:
			#trash_doc.global_position = Vector2(Global.player.global_position.x, 0)
	
#func newLocation() -> void:
	## if player is taking them too long just give it
	#if current_time >= time_out and trash.visible == false:
		#trash_height = player_height
		#trash_width = player_width
		#current_time = 0
	#clear_enemies()
	#ScreenTransition.start_transition2()
	#if player_height == trash_height and player_width == trash_width:
		#trash.visible = true
	#else:
		#trash.visible = false

func checkFiles() -> void:
	# --------- CHECK IF ANY MORE DOC ---------
	for doc in FileNode.get_children():
		if doc.burnable:
			return
			
	spawning = false

func spawn_enemy() -> void:
	var screen_size := get_viewport_rect().size
	var edge = randi() % 4  # Pick a random edge
	var spawn_position: Vector2
	match edge:
		0:  # Top
			spawn_position = Vector2(randf_range(0, screen_size.x), -80)
		1:  # Bottom
			spawn_position = Vector2(randf_range(0, screen_size.x), screen_size.y + 80)
		2:  # Left
			spawn_position = Vector2(-80, randf_range(0, screen_size.y))
		3:  # Right
			spawn_position = Vector2(screen_size.x + 80, randf_range(0, screen_size.y))
	var AntiVirus := AntiVirusPL.instantiate()
	EnemyNode.add_child(AntiVirus)
	AntiVirus.global_position = spawn_position
	AntiVirus.direction = (Global.player.position - AntiVirus.global_position).normalized()
	AntiVirus.speed = randi_range(100, 200)
	
func clear_enemies():
	for child in EnemyNode.get_children():
		child.queue_free()
