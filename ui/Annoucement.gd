extends Label

onready var timer = $FadeTimer

export(String) var signal_name = "annouce"
export(bool) var use_timer = true

func _ready():
	text = ""
	GlobalSignals.connect(signal_name, self, "annouce")

func annouce(message):
	text = message
	
	if use_timer:
		timer.start()


func _on_FadeTimer_timeout():
	text = ""
