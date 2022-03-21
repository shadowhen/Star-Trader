extends Node

const GLOBAL_SIGNAL_NAME = "toggle_sound"

onready var sound_player = $Player

export(Dictionary) var sounds

var playing_sounds = true

func stop():
	sound_player.stop()

func play(sound_name : String):
	if not playing_sounds:
		return
	if not sounds.has(sound_name):
		printerr("%s cannot be played!" % sound_name)
		return
	sound_player.stream = sounds[sound_name]
	sound_player.play()


func toggle():
	playing_sounds = not playing_sounds
	var sound_effects = AudioServer.get_bus_index("SoundEffects")
	AudioServer.set_bus_mute(sound_effects, not playing_sounds)
	GlobalSignals.emit_signal(GLOBAL_SIGNAL_NAME, playing_sounds)
