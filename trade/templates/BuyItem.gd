extends HBoxContainer


signal pressed()

func _ready():
	var sellButton = get_node("Buy2")
	sellButton.connect("pressed", self, "_on_Buy_Pressed")

func _on_Buy_Pressed() -> void:
	if PlayerData.inventory_space >= PlayerData.inventory_cap:
		GlobalSignals.annouce_message("Not enough space to buy cargo")
		return
	
	# only enable buying if inventory is not full
	if (PlayerData.player_stats["InventorySpaceUsed"]["Value"] < PlayerData.player_stats["InventoryCap"]["Value"]):
		
		# debugging
		print("Buy item " + get_node("ItemLabel").text + " for $" + get_node("Price").text)
		
		# take the money for the sale
		var newMoney = int(PlayerData.player_stats["Money"]["Value"]) - int(get_node("Price").text)
		
		# Check the money does not go into negative balance
		if newMoney < 0:
			GlobalSignals.annouce_message("Cannot afford cargo")
			return
		
		PlayerData.player_stats["Money"]["Value"] = str(newMoney)
		
		# update the value for player money and inventory space left on trade screen
			# (yes I know this is *JANK* but couldn't get it to work any other way
			# feel free to revise
		var Owner = get_parent().get_parent().get_parent().get_parent() # gets "Trade" node
		var temp = Owner.get_node("ColorRect")
		var temp1 = temp.get_node("Info")
		var temp2 = temp1.get_node("VBoxContainer")
		var temp3 = temp2.get_node("Money")
		var temp4 = temp2.get_node("InventorySpace")
		
		var MoneyLabel = temp3.get_node("Label")
		var InventoryLabel = temp4.get_node("Label")
		
		print(InventoryLabel.text)
		print(PlayerData.player_stats["InventorySpaceUsed"]["Value"])

		MoneyLabel.text = str(newMoney)
		PlayerData.player_stats["InventorySpaceUsed"]["Value"] = 1 + PlayerData.player_stats["InventorySpaceUsed"]["Value"] # add item to inventory used
		InventoryLabel.text = str(PlayerData.player_stats["InventorySpaceUsed"]["Value"]) + "/" + str(PlayerData.player_stats["InventoryCap"]["Value"])
		
		# add the item to the players inventory data
		for i in PlayerData.inv_data.keys():
			if (PlayerData.inv_data[i]["InvItemID"] == -1): # if slot empty
				print("Adding item to inventory slot " + str(i) + "with itemID" + get_node("ItemID").text + "and week " + str(PlayerData.player_stats["TimeUsed"]["Value"]))
				PlayerData.inv_data[str(i)]["InvItemID"] = int(get_node("ItemID").text)
				PlayerData.inv_data[str(i)]["WeekAquired"] = int(PlayerData.player_stats["TimeUsed"]["Value"])
				break
				
		# update the number of items remaining for the planet on the GUI (subtract 1)
		get_node("Available").text = str(int(get_node("Available").text) - 1)
		
		# update the number of items remaining in the game data for the planet
		var currentPlanet = get_node("PlanetID").text
		var itemID = get_node("ItemID").text
		var newAvailable = int(GameData.planet_inventory[itemID][currentPlanet]) - 1
		GameData.planet_inventory[itemID][currentPlanet] = newAvailable
		
		# remove the item from the trading screen, if no more remaining in stock
		if (int(get_node("Available").text) < 1):
			self.queue_free()
			
		Owner.clean()
		Owner.setup()
		
		GlobalSignals.update_info()
	# if inventory is full and buy pressed
	else:
		GlobalSignals.annouce_message("Not enough cargo space")
		print("Error buying item, inventory full!")
