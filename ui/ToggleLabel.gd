extends Label

export(String) var global_signal_name
export(String) var on_text
export(String) var off_text


func _ready():
	GlobalSignals.connect(global_signal_name, self, "_on_toggle")


func _on_toggle(toggle):
	if toggle:
		text = on_text
	else:
		text = off_text
