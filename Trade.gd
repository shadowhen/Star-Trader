extends Panel

signal close_tradepanel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var template_inv_slot = preload("res://Templates/SellSlot.tscn") # sell slot template
var buy_slot = preload("res://Templates/BuySlot.tscn")

onready var gridcontainer = get_node("ScrollContainer/ItemSellContainer")
onready var buygridcontainer = get_node("Buy/BuyList/VBoxContainer")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventorySpaceUsed = 0
	
	# set up sell slots
	for i in PlayerData.inv_data.keys():
		var itemID = PlayerData.inv_data[i]["InvItemID"]
		if itemID != -1:
			inventorySpaceUsed += 1
			var inv_slot_new = template_inv_slot.instance()
			inv_slot_new.get_node("FoodTrade/Price1").text = "$" + str(GameData.item_data[str(itemID)]["ItemP1SellFor"])
			inv_slot_new.get_node("FoodTrade/Price2").text = "$" + str(GameData.item_data[str(itemID)]["ItemP2SellFor"])
			inv_slot_new.get_node("FoodTrade/Price3").text = "$" + str(GameData.item_data[str(itemID)]["ItemP3SellFor"])
			inv_slot_new.get_node("FoodTrade/Price4").text = "$" + str(GameData.item_data[str(itemID)]["ItemP4SellFor"])
			inv_slot_new.get_node("FoodTrade/Price5").text = "$" + str(GameData.item_data[str(itemID)]["ItemP5SellFor"])
			inv_slot_new.get_node("FoodTrade/Price6").text = "$" + str(GameData.item_data[str(itemID)]["ItemP6SellFor"])
			inv_slot_new.get_node("FoodTrade/Price7").text = "$" + str(GameData.item_data[str(itemID)]["ItemP7SellFor"])
			
			inv_slot_new.get_node("FoodTrade/Sell").text = "Sell (" + str(GameData.item_data[str(itemID)]["ItemP3SellFor"]) + ")"
			
			gridcontainer.add_child(inv_slot_new, true)
			
	# set up buy slots
	for i in GameData.planet_inventory.keys():
		if GameData.planet_inventory[i]["P3Avail"] != 0:
			var buy_slot_new = buy_slot.instance()
			buy_slot_new.get_node("ItemLabel").text = str(GameData.item_data[str(i)]["ItemName"])
			buy_slot_new.get_node("Available").text = str(GameData.planet_inventory[str(i)]["P3Avail"])
			buy_slot_new.get_node("Price").text = str(GameData.item_data[str(i)]["ItemP3BuyFor"])
			
			buygridcontainer.add_child(buy_slot_new, true)
			
	# set the player stats in the small window above the trade window
	get_node("ColorRect/Info/VBoxContainer/InventorySpace/Label").text = str(inventorySpaceUsed) + " / " + str(PlayerData.player_stats["InventoryCap"]["Value"])
	get_node("ColorRect/Info/VBoxContainer/Ship Level/Label").text = str(PlayerData.player_stats["ShipLvl"]["Value"])
	get_node("ColorRect/Info/VBoxContainer/Money/Label").text = str(PlayerData.player_stats["Money"]["Value"])
	get_node("ColorRect/Info/VBoxContainer/Time/Label").text = str(PlayerData.player_stats["TimeUsed"]["Value"]) + " Weeks Used, " + str(51 - PlayerData.player_stats["TimeUsed"]["Value"]) + " Remaining"


func _on_Close_pressed() -> void:
	emit_signal("close_tradepanel")
	pass # Replace with function body.
