extends Node2D

export var move_speed : float = 100.0

func _process(delta):
	var dir = Vector2()
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	dir = dir.normalized()
	
	position += move_speed * dir * delta
