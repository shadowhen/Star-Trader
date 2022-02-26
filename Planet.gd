extends Area2D

signal click_move(new_position)

func _on_Planet_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("move"):
		emit_signal("click_move", global_position)


func _on_Planet_body_entered(body):
	if not body.is_in_group("player"):
		return
	body.interact_planet = true
	print("entering " + name)


func _on_Planet_body_exited(body):
	if not body.is_in_group("player"):
		return
	body.interact_planet = false
	print("leaving " + name)
