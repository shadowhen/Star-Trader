extends Panel

signal close_tradepanel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var template_inv_slot = preload("res://trade/templates/SellSlot.tscn") # sell slot template
var buy_slot = preload("res://trade/templates/BuySlot.tscn")

onready var gridcontainer = get_node("ScrollContainer/ItemSellContainer")
onready var buygridcontainer = get_node("Buy/BuyList/VBoxContainer")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()

func setup():
	var inventorySpaceUsed = 0

	# parse current Planet
	var currentPlanet = str(PlayerData.player_stats["CurrentPlanet"]["Value"])
	if (currentPlanet == "Planet1"):
		currentPlanet = "1"
	elif (currentPlanet == "Planet2"):
		currentPlanet = "2"
	elif (currentPlanet == "Planet3"):
		currentPlanet = "3"
	elif (currentPlanet == "Planet4"):
		currentPlanet = "4"
	elif (currentPlanet == "Planet5"):
		currentPlanet = "5"
	elif (currentPlanet == "Planet6"):
		currentPlanet = "6"
	elif (currentPlanet == "Planet7"):
		currentPlanet = "7"


	# temp
	get_node("Buy/Top/DateLabelTemp").text = str(PlayerData.player_stats["TimeUsed"]["Value"])
	
	# set up sell slots
	for i in PlayerData.inv_data.keys():
		var itemID = PlayerData.inv_data[i]["InvItemID"]

		if itemID != -1:
			inventorySpaceUsed += 1
			var inv_slot_new = template_inv_slot.instance()
			inv_slot_new.get_node("FoodTrade/ItemLabel").text =  str(GameData.item_data[str(itemID)]["ItemName"])
			inv_slot_new.get_node("FoodTrade/InvSlotLabel").text =  str(i)
			inv_slot_new.get_node("FoodTrade/ItemDate").text =  str(PlayerData.inv_data[i]["WeekAquired"])
			
			# set prices
			var oldPrice = int(GameData.item_data[str(itemID)]["ItemP" + currentPlanet + "SellFor"])
			var perishableValue = int(GameData.item_data[str(itemID)]["ItemPerishable"]) # remove this * num weeks in cargo from value
			var currentDate = int(PlayerData.player_stats["TimeUsed"]["Value"])
			var itemPurchaseDate = int(PlayerData.inv_data[str(i)]["WeekAquired"])
			var timeInInventory = currentDate - itemPurchaseDate
			var newPrice = oldPrice - (perishableValue * timeInInventory)
			
			# if new price is negative then make 0 instead
			if (newPrice < 0):
				newPrice = 0
			
			inv_slot_new.get_node("FoodTrade/ItemPriceLabel").text =  str(newPrice)
			inv_slot_new.get_node("FoodTrade/Sell").text = "Sell for $" + str(newPrice)

			gridcontainer.add_child(inv_slot_new, true)

	# set up buy slots
	for i in GameData.planet_inventory.keys():
		if GameData.planet_inventory[i]["P" + currentPlanet + "Avail"] != 0:
			var buy_slot_new = buy_slot.instance()
			buy_slot_new.get_node("ItemLabel").text = str(GameData.item_data[str(i)]["ItemName"])
			buy_slot_new.get_node("Available").text = str(GameData.planet_inventory[str(i)]["P" + currentPlanet + "Avail"])
			buy_slot_new.get_node("Price").text = str(GameData.item_data[str(i)]["ItemP" + currentPlanet + "BuyFor"])
			buy_slot_new.get_node("ItemID").text = str(i)
			buy_slot_new.get_node("PlanetID").text = "P" + currentPlanet + "Avail"
			buygridcontainer.add_child(buy_slot_new, true)

	# set the player stats in the small window above the trade window
	get_node("ColorRect/Info/VBoxContainer/InventorySpace/Label").text = str(inventorySpaceUsed) + " / " + str(PlayerData.player_stats["InventoryCap"]["Value"])
	get_node("ColorRect/Info/VBoxContainer/Ship Level/Label").text = str(PlayerData.player_stats["ShipLvl"]["Value"])
	get_node("ColorRect/Info/VBoxContainer/Money/Label").text = str(PlayerData.player_stats["Money"]["Value"])
	get_node("ColorRect/Info/VBoxContainer/Time/Label").text = str(PlayerData.player_stats["TimeUsed"]["Value"]) + " Weeks Used, " + str(52 - PlayerData.player_stats["TimeUsed"]["Value"]) + " Remaining"

func clean():
	# Remove and queue free all children from the containers
	for c in gridcontainer.get_children():
		gridcontainer.remove_child(c)
		c.queue_free()
	for c in buygridcontainer.get_children():
		buygridcontainer.remove_child(c)
		c.queue_free()

func _on_Close_pressed() -> void:
	emit_signal("close_tradepanel")
	pass # Replace with function body.

func _planet_exited() -> void: # close trade panel when leaving planet
	emit_signal("close_tradepanel")
	pass # Replace with function body.
