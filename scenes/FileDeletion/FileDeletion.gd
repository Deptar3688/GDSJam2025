extends Node2D

@onready var trash = $Trash
@onready var trash_doc = $TrashDoc
@onready var AntiVirusPL := preload("res://scenes/FileDeletion/Enemies/AntiVirus.tscn")
@onready var FilePL := preload("res://scenes/FileDeletion/TrashDoc.tscn")
@onready var EnemyNode := $Enemies
@onready var FileNode := $Files
@onready var bg := $BG
@onready var anim := $AnimationTree


@export var numFiles : float

@export var spawning : bool = false
var spawn_time := 0.5
var current_spawn_time : float
var full : bool

@export var start: bool
	

func _ready() -> void:
	current_spawn_time = 0.0
	full = false
	start = false
	%FileDeleteStage.destroyed.connect(func(): start = true)
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
	
	
func _process(delta: float) -> void:
	if start:
		Global.current_stage = Global.Stage.TRASH
		anim.play("start")
		start = false
	
	# ---- MAKE UN INVISBLE -----
	if trash.visible:
		for child in FileNode.get_children():
			child.visible = true
	
	# ------ INCREMENT TIMER -------
	current_spawn_time += delta 
	#current_time += delta
	
	# --------- IF TIME IS UP SPAWN ENEMY -----------
	if current_spawn_time >= spawn_time and spawning:
		current_spawn_time = 0
		spawn_enemy()
	
	# --------- CHECK IF ANY MORE DOC ---------
	checkFiles()
	
	

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
