extends HBoxContainer

signal sold

func _ready():
	var sellButton = get_node("Sell")
	sellButton.connect("pressed", self, "_on_Sell_Pressed")

func setup(i, itemID, currentPlanet):
	get_node("ItemLabel").text = str(GameData.item_data[str(itemID)]["ItemName"])
	get_node("InvSlotLabel").text = str(i)
	get_node("ItemDate").text =  str(PlayerData.inv_data[i]["WeekAquired"])
	
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
	
	get_node("ItemPriceLabel").text =  str(newPrice)
	get_node("Sell").text = "Sell for $" + str(newPrice)

func _on_Sell_Pressed() -> void:

	# debugging
	print("Sell inventory slot #" + get_node("InvSlotLabel").text)
	
	# give player the money from the sale
	var newMoney = int(PlayerData.player_stats["Money"]["Value"]) + int(get_node("ItemPriceLabel").text)
	PlayerData.player_stats["Money"]["Value"] = str(newMoney)
	
#	# update the value for player money and inventory space left on trade screen
#	# (yes I know this is *JANK* but couldn't get it to work any other way
#	# feel free to revise
#	var Owner = get_parent().get_parent().get_parent().get_parent() # gets "Trade" node
#	var temp = Owner.get_node("ColorRect")
#	var temp1 = temp.get_node("Info")
#	var temp2 = temp1.get_node("VBoxContainer")
#	var temp3 = temp2.get_node("Money")
#	var temp4 = temp2.get_node("InventorySpace")
#
#	var MoneyLabel = temp3.get_node("Label")
#	var InventoryLabel = temp4.get_node("Label")
#
#	MoneyLabel.text = str(newMoney)
	PlayerData.player_stats["InventorySpaceUsed"]["Value"] -= 1 # remove item from inventory used
#	InventoryLabel.text = str(PlayerData.player_stats["InventorySpaceUsed"]["Value"]) + "/" + str(PlayerData.player_stats["InventoryCap"]["Value"])
#
#	# remove the item from the players inventory data
	PlayerData.inv_data[get_node("InvSlotLabel").text]["InvItemID"] = -1
	PlayerData.inv_data[get_node("InvSlotLabel").text]["InvTimeIn"] = -1

	emit_signal("sold")
	GlobalSignals.update_info()
	# remove the item from the trading screen
	self.queue_free()
