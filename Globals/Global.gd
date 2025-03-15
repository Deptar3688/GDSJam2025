extends Node

var player: Player

enum Stage {TUTORIAL, THESIS, TRASH, CATS, SYSTEM32}

var current_stage: Stage = Stage.TUTORIAL

signal player_damaged(new_health: int)

var player_has_moved: bool = false
signal player_has_moved_first_time()
