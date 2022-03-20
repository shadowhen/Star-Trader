extends Area2D

signal click_move(new_position)
signal player_enter(planet)
signal player_exit(planet)

export(String) var planet_name = ""
onready var planet_label = $PlanetLabel
var available_jobs = []

func _ready():
	planet_label.text = planet_name

func _on_Planet_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("move"):
		GlobalSignals.annouce_state_message("Traveling to %s" % planet_name)
		emit_signal("click_move", global_position)

func _on_Planet_body_entered(body):
	if not body.is_in_group("player"):
		return
	print("entering " + name)
	PlayerData.player_stats["CurrentPlanet"]["Value"] = name

#	var tradepanel = load("res://trade/Trade.tscn").instance()
#	add_child(tradepanel)
#	get_node("Trade").connect("close_tradepanel", self, "close_tradepanel")

	emit_signal("player_enter", self)


func _on_Planet_body_exited(body):
	if not body.is_in_group("player"):
		return
	print("leaving " + name)
	PlayerData.player_stats["CurrentPlanet"]["Value"] = "-1"
	emit_signal("player_exit", self)
