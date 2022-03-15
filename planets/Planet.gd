extends Area2D

signal click_move(new_position)
signal player_enter
signal player_exit

func _on_Planet_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("move"):
		emit_signal("click_move", global_position)

func _on_Planet_body_entered(body):
	if not body.is_in_group("player"):
		return
	print("entering " + name)
	PlayerData.player_stats["CurrentPlanet"]["Value"] = name

#	var tradepanel = load("res://trade/Trade.tscn").instance()
#	add_child(tradepanel)
#	get_node("Trade").connect("close_tradepanel", self, "close_tradepanel")

	emit_signal("player_enter")


func _on_Planet_body_exited(body):
	if not body.is_in_group("player"):
		return
	print("leaving " + name)
	PlayerData.player_stats["CurrentPlanet"]["Value"] = "-1"
	emit_signal("player_exit")
