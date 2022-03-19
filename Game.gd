extends Node

enum GameState { TRAVEL, DOCKED, WINNER, LOSER }
var game_state = GameState.TRAVEL

onready var shared_ui = $GUI/SharedUI
onready var week_timer = $WeekTimer
onready var clock = $GUI/Clock

export(int) var player_cash_balance = 100
export(int) var weeks_left = 52

# These variables are used to upgrade the ship. 
onready var bullet_sprite = get_node("Player/Sprite")
onready var panel_sprite = get_node("GUI/SharedUI/Tabs/Upgrade/Container/LeftSide/ShipTextureRect")
var player_ship_level = 1
var player_tex1 = preload("res://player/player-ship-inventory-1.png")
var player_tex2 = preload("res://player/player-ship-inventory-2.png")

func _ready():
	for planet in get_tree().get_nodes_in_group("planets"):
		planet.connect("player_enter", self, "_on_Planet_player_enter")
		planet.connect("player_exit", self, "_on_Planet_player_exit")
		get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/CashAmount").text = "Credits: " + str(player_cash_balance)
		
		if player_ship_level == 1:
			get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/Label").text = "Upgrade 1: Inventory +3. 300 monies. "
		elif player_ship_level == 2:
			get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/Label").text = "Upgrade 1: Inventory +5. 800 monies. "

func _process(delta):
	if week_timer.is_stopped():
		clock.value = 0
	else:
		# Updates the radial value of the ui clock
		clock.value = week_timer.wait_time - week_timer.time_left

func _unhandled_input(event):
	if event.is_action_pressed("trade") and game_state == GameState.DOCKED:
		shared_ui.visible = not shared_ui.visible

func _on_Planet_player_enter():
	game_state = GameState.DOCKED
	shared_ui.show()
	shared_ui.update_info()
	
	# Pause the game timer
	week_timer.paused = true
	PlayerData.player_stats["TimeUsed"]["Value"] = clock.value
	
func _on_Planet_player_exit():
	game_state = GameState.TRAVEL
	shared_ui.hide()
	
	# Starts timer if it has not started yet
	if week_timer.is_stopped():
		week_timer.start()
	
	# Unpause the game timer
	week_timer.paused = false

# This function implements both ship upgrades and visual ship upgrades.  
func _upgrade_ship():
	# Logic for first upgrade.
	if player_ship_level == 1:
		if player_cash_balance < 300:
			print("You do not have enough credits to redeem your first upgrade. ")
		else:
			player_ship_level = 2
			PlayerData.player_stats["ShipLvl"]["Value"] = 2
			PlayerData.player_stats["InventoryCap"]["Value"] = 13
			player_cash_balance = player_cash_balance - 300
			bullet_sprite.set_texture(player_tex1)
			panel_sprite.set_texture(player_tex1)
			print("You've acquired '1st Upgrade'! ")

	# Logic for second upgrade.
	elif player_ship_level == 2:
		if player_cash_balance < 800:
			print("You do not have enough credits to redeem your second upgrade. ")
		else:
			player_ship_level = 3
			PlayerData.player_stats["ShipLvl"]["Value"] = 3
			PlayerData.player_stats["InventoryCap"]["Value"] = 17
			player_cash_balance = player_cash_balance - 800
			bullet_sprite.set_texture(player_tex2)
			panel_sprite.set_texture(player_tex2)
			print("You've acquired '2nd Upgrade'! ")

	# Fully Upgraded.
	else:
		print("Your ship is fully upgraded traveler! ")

# Signal function for WeekTimer's timeout
func _on_WeekTimer_timeout():
	# Countdown the number of weeks left
	weeks_left -= 1
	
	# Ends the game when time runs out completely
	if weeks_left <= 0:
		game_over()

# Declares the game to be game over
func game_over():
	print("All weeks are exhausted")
