extends HBoxContainer

signal pressed()

func _ready():
	var sellButton = get_node("Sell")
	sellButton.connect("pressed", self, "_on_Sell_Pressed")

func _on_Sell_Pressed() -> void:

	# debugging
	print("Sell inventory slot #" + get_node("InvSlotLabel").text)

	# give player the money from the sale
	var newMoney = int(PlayerData.player_stats["Money"]["Value"]) + int(get_node("ItemPriceLabel").text)
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

	MoneyLabel.text = str(newMoney)
	PlayerData.player_stats["InventorySpaceUsed"]["Value"] -= 1 # remove item from inventory used
	InventoryLabel.text = str(PlayerData.player_stats["InventorySpaceUsed"]["Value"]) + "/" + str(PlayerData.player_stats["InventoryCap"]["Value"])

	# remove the item from the players inventory data
	PlayerData.inv_data[get_node("InvSlotLabel").text]["InvItemID"] = -1
	PlayerData.inv_data[get_node("InvSlotLabel").text]["InvTimeIn"] = -1


	# remove the item from the trading screen
	self.queue_free()
