extends Node

const GLOBAL_SIGNAL_NAME = "toggle_music"

onready var music_player = $Player
var started = false

func start():
	if started:
		return
	started = true
	play()

func play():
	music_player.play()
	GlobalSignals.emit_signal(GLOBAL_SIGNAL_NAME, true)


func stop():
	music_player.stop()
	GlobalSignals.emit_signal(GLOBAL_SIGNAL_NAME, false)


func toggle():
	if music_player.playing:
		stop()
	else:
		play()
