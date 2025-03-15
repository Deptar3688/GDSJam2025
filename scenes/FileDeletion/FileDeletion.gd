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
var spawn_time := 1.0
var current_spawn_time : float

var full : bool

@export var start: bool

@export var numberWaves := 2
var currentWave : int

func _ready() -> void:
	Global.player_died.connect(_on_player_death)
	current_spawn_time = 0.0
	full = false
	start = false
	currentWave = 1
	%FileDeleteStage.destroyed.connect(func(): start = true)
	#current_time = 0.0
	
	# ------ INITALIZE NUMBER OF FILES ----------
	numFiles = randi_range(3,5)
	
	# ------ ADD THE NUMBER OF FILES TO THE SCENE -------
	spawnFiles()

func _on_player_death():
	if not trash.visible:
		return
	anim.play("RESET")
	%FileDeleteStage.disabled = false
	%FileDeleteStage.current_health = 5
	current_spawn_time = 0.0
	full = false
	start = false
	currentWave = 1
	numFiles = randi_range(3,5)
	spawning = false
	wipeFiles()
	trash.visible = false
	trash.spawned = false
	spawnFiles()

func wipeFiles() -> void:
	for child in FileNode.get_children():
		child.queue_free()
		

func spawnFiles() -> void:
	# ------ ADD THE NUMBER OF FILES TO THE SCENE -------
	for i in range(numFiles):
		var trash_doc := FilePL.instantiate()
		FileNode.add_child(trash_doc)
		var temp := 0
		var spawn_pos =Vector2(randf_range(0, 400), randf_range(0,300))
		
		trash_doc.visible = false
		trash_doc.global_position = spawn_pos
	

func _process(delta: float) -> void:
	if start:
		anim.play("start")
		start = false
		%HUD.set_text("Level 2: TrashCan")
	
	if trash.visible and not trash.spawned:
		trash.spawn()
		trash.spawned = true
	
	# ---- MAKE UN INVISBLE -----
	
	if trash.visible:
		for child in FileNode.get_children():
			if child is TrashDoc:
				child.visible = true
				child.spawn()
				child.spawned = true
			
	
	# ------ INCREMENT TIMER -------
	current_spawn_time += delta 
	#current_time += delta
	
	# --------- IF TIME IS UP SPAWN ENEMY -----------
	if current_spawn_time >= spawn_time and spawning:
		current_spawn_time = 0
		spawn_enemy()
	
	# --------- CHECK IF ANY MORE DOC ---------
	if trash.visible:
		checkFiles()
	
	

func checkFiles() -> void:
	# --------- CHECK IF ANY MORE DOC ---------
	for doc in FileNode.get_children():
		if doc.burnable:
			return
	
	if currentWave < numberWaves:
		spawnFiles()
		currentWave += 1
	elif spawning and trash.visible:
		spawning = false
		trash.poof()
		await get_tree().create_timer(4.0).timeout
		get_parent().CatPictureDestruc.disabled = false

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
