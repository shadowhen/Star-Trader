extends Node2D

export(int) var cash
export(int) var upgrade_level
export(NodePath) var start_position_path

onready var parent = get_parent()
onready var ship = get_node("Ship")

var interact_planet = true

func _ready():
	# Set where the player's ship should start
	var start_position = get_node(start_position_path)
	if start_position != null:
		position = start_position.global_position

func _unhandled_input(event):
	# Interacts the planet when the player presses an action
	if interact_planet and event.is_action_pressed("trade"):
		parent.request_planet_interaction()

func go_to_planet(target):
	# Prevents player from picking another planet to move
	# while the ship is traveling
	if interact_planet:
		interact_planet = false
		ship.go_to_planet(target)

# This function implements both ship upgrades.  
func _ship_upgrade(current_balance, current_ship_upgrade):
	# Logic for first upgrade. 
	if current_ship_upgrade == 0:
		if current_balance < 500:
			print("You do not have enough credits to redeem your first upgrade. ")
		else:
			current_ship_upgrade += 1
			current_balance = current_balance - 500
			print("Your ship has been successfully upgraded! ")

	# Logic for second upgrade.
	elif current_ship_upgrade == 1:
		if current_balance < 3000:
			print("You do not have enough credits to redeem your second upgrade. ")
		else:
			current_ship_upgrade += 1
			current_balance = current_balance - 3000
			print("Your ship has been successfully upgraded! ")

	# Fully Upgraded.
	else:
		print("Your ship is fully upgraded traveler! ")

func _on_Ship_reached_target():
	# Allows the player to interact with the planet
	interact_planet = true
