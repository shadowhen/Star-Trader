extends Node

onready var player = get_node("Player")

func _ready():
	for planet in $Planets.get_children():
		planet.connect("click_move", self, "_on_click_move")

func request_planet_interaction() -> void:
	$GUI/Trade.visible = not $GUI/Trade.visible

func _on_click_move(target : Vector2) -> void:
	player.go_to_planet(target)
	$GUI/Trade.hide()
