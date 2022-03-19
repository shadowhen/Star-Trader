extends Control

onready var description = $Popup/MarginContainer/Info/Description

func _on_Button_pressed():
	hide()
	queue_free()
