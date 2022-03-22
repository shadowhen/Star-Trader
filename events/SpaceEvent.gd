extends Area2D

signal player_enter_asteroid(spaceevent)
signal player_enter_pirate_zone(spaceevent)
signal player_exit_asteroid(spaceevent)

#export(String) var planet_name = ""
#onready var planet_label = $PlanetLabel
#var available_jobs = []

#func _ready():
#	planet_label.text = planet_name

#func _on_Planet_input_event(viewport, event, shape_idx):
#	if event.is_action_pressed("move"):
#		GlobalSignals.annouce_state_message("Traveling to %s" % planet_name)
#		SoundPlayer.play("travel")
#		emit_signal("click_move", global_position)

func _on_AsteroidBelt_body_entered(body):
	if not body.is_in_group("player"):
		return
	print("entering " + name)

#	var tradepanel = load("res://trade/Trade.tscn").instance()
#	add_child(tradepanel)
#	get_node("Trade").connect("close_tradepanel", self, "close_tradepanel")

	emit_signal("player_enter_asteroid", self)


func _on_AsteroidBelt_body_exited(body):
	if not body.is_in_group("player"):
		return
	print("leaving " + name)
	emit_signal("player_exit_asteroid", self)
	
func _on_PirateZone_body_entered(body):
	if not body.is_in_group("player"):
		return
	print("entering " + name)

#	var tradepanel = load("res://trade/Trade.tscn").instance()
#	add_child(tradepanel)
#	get_node("Trade").connect("close_tradepanel", self, "close_tradepanel")

	emit_signal("player_enter_pirate_zone", self)
