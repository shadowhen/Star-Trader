extends Node

enum GameState { TRAVEL, DOCKED, WINNER, LOSER }
var game_state = GameState.TRAVEL

onready var shared_ui = $GUI/SharedUI

export(int) var player_cash_balance = 100
export(int) var player_ship_level = 0

func _ready():
	for planet in get_tree().get_nodes_in_group("planets"):
		planet.connect("player_enter", self, "_on_Planet_player_enter")
		planet.connect("player_exit", self, "_on_Planet_player_exit")

func _unhandled_input(event):
	if event.is_action_pressed("trade") and game_state == GameState.DOCKED:
		shared_ui.visible = not shared_ui.visible

func _on_Planet_player_enter():
	game_state = GameState.DOCKED
	shared_ui.show()
	shared_ui.update_info()
	
func _on_Planet_player_exit():
	game_state = GameState.TRAVEL
	shared_ui.hide()


# This function implements both ship upgrades.  
func _upgrade_ship():
	# Logic for first upgrade. 
	if player_ship_level == 0:
		if player_cash_balance < 500:
			print("You do not have enough credits to redeem your first upgrade. ")
		else:
			player_ship_level += 1
			player_cash_balance = player_cash_balance - 500
			print("Your ship has been successfully upgraded! ")

	# Logic for second upgrade.
	elif player_ship_level == 1:
		if player_cash_balance < 3000:
			print("You do not have enough credits to redeem your second upgrade. ")
		else:
			player_ship_level += 1
			player_cash_balance = player_cash_balance - 3000
			print("Your ship has been successfully upgraded! ")

	# Fully Upgraded.
	else:
		print("Your ship is fully upgraded traveler! ")
