extends Node

# https://kidscancode.org/godot_recipes/audio/audio_manager/

const NUM_PLAYERS = 16

var available = []
var queue = []

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in range(NUM_PLAYERS):
		var p := AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.volume_db -= 10
		p.finished.connect(func():
			_on_stream_finished(p)
			)
		
func _on_stream_finished(stream: AudioStreamPlayer):
	available.append(stream)
	stream.pitch_scale = 1.0

func play(sound_path):
	queue.append(sound_path)
	check_queue()
	
func _process(delta):
	check_queue()

func check_queue():
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].pitch_scale = randf_range(0.85, 1.15)
		available[0].play()
		available.pop_front()
