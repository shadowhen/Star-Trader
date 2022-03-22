extends Node

enum GameState { TRAVEL, DOCKED, GAME_OVER }
var game_state = GameState.TRAVEL

onready var shared_ui = $GUI/SharedUI
onready var week_timer = $WeekTimer
onready var clock = $GUI/Clock
onready var simulation = $Simulation
onready var objective = $GUI/Objective

export(int) var money_win = 1000
export(int) var weeks_left = 52
export(PackedScene) var popup_template

# Used to count before triggering an random event
var random_event_time_counter = 0

# These variables are used to upgrade the ship. 
onready var bullet_sprite = get_node("Player/Sprite")
onready var panel_sprite = get_node("GUI/SharedUI/Tabs/Upgrade/Container/LeftSide/ShipTextureRect")
var player_ship_level = 1
var player_tex1 = preload("res://player/player-ship-inventory-1.png")
var player_tex2 = preload("res://player/player-ship-inventory-2.png")

func _ready():
	MusicPlayer.start()
	SoundPlayer.stop()
	
	objective.text = "Click a planet to travel and the game will start."
	
	# Randomize seed for random generated jobs
	randomize()
	
	for planet in get_tree().get_nodes_in_group("planets"):
		planet.connect("player_enter", self, "_on_Planet_player_enter")
		planet.connect("player_exit", self, "_on_Planet_player_exit")
		get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/CashAmount").text = "Money: " + str(PlayerData.money)
		
		if player_ship_level == 1:
			get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/Label").text = "Upgrade 1: Inventory +3. 100 monies. "
		elif player_ship_level == 2:
			get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/Label").text = "Upgrade 1: Inventory +5. 250 monies. "
			
	for rand_event in get_tree().get_nodes_in_group("events"):
		rand_event.connect("player_enter_asteroid", self, "_on_AsteroidBelt_player_enter")
		rand_event.connect("player_enter_pirate_zone", self, "_on_PirateZone_player_enter")
		
	simulation.randomize_jobs()
	PlayerData.connect("job_removed", self, "_on_PlayerData_job_removed")

func _process(delta):
	if week_timer.is_stopped():
		clock.value = 0
	else:
		# Updates the radial value of the ui clock
		clock.value = PlayerData.time_used
	
	if Input.is_action_just_pressed("restart"):
		GameData.restart()
		PlayerData.restart()
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("toggle_music"):
		MusicPlayer.toggle()
	if Input.is_action_just_pressed("toggle_sound"):
		SoundPlayer.toggle()

func _unhandled_input(event):
	if event.is_action_pressed("trade") and game_state == GameState.DOCKED:
		shared_ui.visible = not shared_ui.visible

func _on_Planet_player_enter(planet):
	if game_state != GameState.GAME_OVER:
		objective.text = "Maintain balance of 1000 monies, so your family can live in paradise before clock runs out."
	
	GlobalSignals.annouce_state_message("Docked at %s" % planet.planet_name)
	
	if game_state != GameState.GAME_OVER:
		game_state = GameState.DOCKED
	
	shared_ui.show()
	shared_ui.update_info(planet)
	
	SoundPlayer.play("dock")
	
	var complete_jobs = []
	for job in PlayerData.job_log:
		if job.destination == planet:
			complete_jobs.push_back(job)
	for job in complete_jobs:
		PlayerData.remove_job(job)
		job.queue_free()
	
	# Pause the game timer
	week_timer.paused = true
	PlayerData.player_stats["TimeUsed"]["Value"] = clock.value

func _on_Planet_player_exit(planet):
	if game_state != GameState.GAME_OVER:
		game_state = GameState.TRAVEL
	
	shared_ui.hide()
	
	# Starts timer if it has not started yet
	if week_timer.is_stopped():
		week_timer.start()
	
	# Unpause the game timer
	week_timer.paused = false
	
# This function handles outcomes of a player entering an asteroid field
func _on_AsteroidBelt_player_enter(rand_event):
	# Logic for handling what happens in an asteroid field
	
	var rng = RandomNumberGenerator.new()
	var cargo_lost = -1
	var i = 1
	var itemsRemoved = 0
	var rand_num = -1 
	var randrange = pow(player_ship_level, 2) # higher the ship level, lower the chance of losing cargo
	
	rng.randomize()
	rand_num = rng.randi_range(0, randrange)
	if rand_num == 0:
		# Player will lose 1-3 bits of cargo if they have any
		if PlayerData.player_stats["InventorySpaceUsed"]["Value"] > 0:
			
			# remove 1-3 items from the players inventory data
			cargo_lost = rng.randi_range(1, 3)
			print("Losing: ", cargo_lost, " bits of cargo!")
			i = 1
			itemsRemoved = 0
			
			for item in PlayerData.inv_data:
				if itemsRemoved > cargo_lost - 1:
					break
					
				# If there's an item, remove it (up to 3)
				if PlayerData.inv_data[str(i)]["InvItemID"] != -1:
					# Remove item
					PlayerData.inv_data[str(i)]["InvItemID"] = -1
					PlayerData.inv_data[str(i)]["InvTimeIn"] = -1
					PlayerData.player_stats["InventorySpaceUsed"]["Value"] -= 1 
					itemsRemoved += 1
				i += 1
				
			print("Successfully broke through! Lost ", itemsRemoved, " bits of cargo!")	
			itemsRemoved = 0	
			i = 1				

# This function handles outcomes of a player entering the pirate zone
func _on_PirateZone_player_enter(rand_event):
	# Logic for handling what happens in an pirate zone
	
	var rng = RandomNumberGenerator.new()
	var cargo_lost = -1
	var i = 1
	var itemsRemoved = 0
	var rand_num = -1 
	var randrange = 10 - pow(player_ship_level, 2) # higher the ship level, the higher the chance of losing cargo
	
	rng.randomize()
	rand_num = rng.randi_range(0, randrange)
	if rand_num == 0:
		# Player will lose 1-3 bits of cargo if they have any
		if PlayerData.player_stats["InventorySpaceUsed"]["Value"] > 0:
			
			# remove 1-3 items from the players inventory data
			cargo_lost = rng.randi_range(1, 3)
			print("Losing: ", cargo_lost, " bits of cargo!")
			i = 1
			itemsRemoved = 0
			
			for item in PlayerData.inv_data:
				if itemsRemoved > cargo_lost - 1:
					break
					
				# If there's an item, remove it (up to 3)
				if PlayerData.inv_data[str(i)]["InvItemID"] != -1:
					# Remove item
					PlayerData.inv_data[str(i)]["InvItemID"] = -1
					PlayerData.inv_data[str(i)]["InvTimeIn"] = -1
					PlayerData.player_stats["InventorySpaceUsed"]["Value"] -= 1 
					itemsRemoved += 1
				i += 1
				
			print("Successfully broke through! Lost ", itemsRemoved, " bits of cargo!")	
			itemsRemoved = 0	
			i = 1				

# This function implements both ship upgrades and visual ship upgrades.  
func _upgrade_ship():
	# Logic for first upgrade.
	if player_ship_level == 1:
		if PlayerData.money < 100:
			print("You do not have enough credits to redeem your first upgrade. ")
		else:
			player_ship_level = 2
			PlayerData.player_stats["ShipLvl"]["Value"] = 2
			PlayerData.player_stats["InventoryCap"]["Value"] = 13
			PlayerData.money -= 100
			get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/Label").text = "Upgrade 2: Inventory +5. 250 monies. "
			get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/CashAmount").text = "Money: " + str(PlayerData.player_stats["Money"]["Value"])
			bullet_sprite.set_texture(player_tex1)
			panel_sprite.set_texture(player_tex1)
			print("You've acquired '1st Upgrade'! ")

	# Logic for second upgrade.
	elif player_ship_level == 2:
		if PlayerData.money < 250:
			print("You do not have enough credits to redeem your second upgrade. ")
		else:
			player_ship_level = 3
			PlayerData.player_stats["ShipLvl"]["Value"] = 3
			PlayerData.player_stats["InventoryCap"]["Value"] = 17
			PlayerData.money -= 250
			get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/Label").text = "Fully Upgraded! "
			get_node("GUI/SharedUI/Tabs/Upgrade/Container/RightSide/VBoxContainer/CashAmount").text = "Money: " + str(PlayerData.player_stats["Money"]["Value"])
			bullet_sprite.set_texture(player_tex2)
			panel_sprite.set_texture(player_tex2)
			print("You've acquired '2nd Upgrade'! ")

	# Fully Upgraded.
	else:
		print("Your ship is fully upgraded traveler! ")

# Signal function for WeekTimer's timeout
func _on_WeekTimer_timeout():
	if game_state == GameState.GAME_OVER:
		return
	
	# Countdown the number of weeks left
	#weeks_left -= 1
	PlayerData.time_used += 1
	random_event_time_counter += 1
	
	# Ends the game when time runs out completely
	if PlayerData.time_used >= weeks_left:
		game_over()
	
	# Randomizes planets when the counter reaches this number
	if random_event_time_counter >= 3:
		random_event_time_counter = 0
		simulation.clear_planet_jobs()
		simulation.randomize_jobs()
		GameData.random_add_items()
		GlobalSignals.annouce_message("New jobs available")

# Declares the game to be game over
func game_over():
	game_state = GameState.GAME_OVER
	
	if PlayerData.money >= money_win:
		objective.text = "You won! Your family will now live in paradise."
	else:
		objective.text = "You lost. Your family won't be to able live in paradise."
	
	var temp = popup_template.instance()
	$GUI.add_child(temp)
	temp.description.text = objective.text

func _on_PlayerData_job_removed(job):
	var temp = popup_template.instance()
	
	var desc = "Job Complete\nDeliver %s cargo to %s\nReward: %s monies"
	var desc_args = [job.cargo_space, job.destination.planet_name, job.money_reward]
	$GUI.add_child(temp)
	temp.description.text = desc % desc_args
