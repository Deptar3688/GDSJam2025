extends Node

var player: Player

signal player_damaged(new_health: int)


var player_has_moved: bool = false
signal player_has_moved_first_time()
