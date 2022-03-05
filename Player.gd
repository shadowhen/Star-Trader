extends KinematicBody2D

const SPEED = 250.0

export var current_balance : int = 100

var move_pressed = false
var target_position = Vector2()
var interact_planet = false

func _ready():
	var planets = get_tree().get_nodes_in_group("planets")
	for planet in planets:
		planet.connect("click_move", self, "_update_target_position")

	var trades = get_tree().get_nodes_in_group("trade")
	for trade in trades:
		trade.connect("trade_amount", self, "_conduct_trade")

func _unhandled_input(event):
	if interact_planet and event.is_action_pressed("trade"):
		$"../GUI/Trade/".visible = not $"../GUI/Trade/".visible

func _update_target_position(target_position):
	self.target_position = target_position
	
func _conduct_trade(cargo_type, currency, amount):
	#print("traded %d for %s" % [amount, ItemTrade.get_cargo_str(cargo_type)])
	
	# Calculate new balance
	current_balance += currency
	print("Current balance: %d" % current_balance)

func _physics_process(delta):
	var direction_vec = target_position - global_position
	var direction_normal = direction_vec.normalized()
	
	if direction_vec.length() < 5:
		return
	move_and_collide(direction_normal * SPEED * delta)

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
