extends KinematicBody2D

export var current_balance : int = 100

var move_pressed = false

var interact_planet = false

# movement variables
var destination = Vector2()
var target_position = Vector2()
var velocity = Vector2()
var speed = 0
var max_speed = 200
var acceleration = 50
var is_moving = false

func _ready():
	var planets = get_tree().get_nodes_in_group("planets")
	for planet in planets:
		planet.connect("click_move", self, "_update_destination")

	var trades = get_tree().get_nodes_in_group("trade")
	for trade in trades:
		trade.connect("trade_amount", self, "_conduct_trade")

func _unhandled_input(event):
	if interact_planet and event.is_action_pressed("trade"):
		$"../GUI/Trade/".visible = not $"../GUI/Trade/".visible

# Updates the ships destination
func _update_destination(target_position):
	destination = target_position
	is_moving = true

# Moves the ship to the target destination at the set speed
func _physics_process(delta):
	_movement_loop(delta)
		
func _movement_loop(delta):
	if is_moving == false:
		speed = 0
	else:
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
	
	velocity = position.direction_to(destination) * speed
	look_at(destination)
	if position.distance_to(destination) > 5:
		velocity = move_and_slide(velocity)
	else:
		is_moving = false
	
func _conduct_trade(cargo_type, currency, amount):
	#print("traded %d for %s" % [amount, ItemTrade.get_cargo_str(cargo_type)])
	
	# Calculate new balance
	current_balance += currency
	print("Current balance: %d" % current_balance)

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
