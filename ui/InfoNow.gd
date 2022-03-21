extends Control

onready var time_label = $Info/Time/Label
onready var money_label = $Info/Money/Label
onready var ship_label = $Info/ShipLevel/Label
onready var inventory_space_label = $Info/InventorySpace/Label

func _ready():
	GlobalSignals.connect("info_update", self, "update_info")

func update_info():
	inventory_space_label.text = str(PlayerData.inventory_space) + " / " + str(PlayerData.player_stats["InventoryCap"]["Value"])
	ship_label.text = str(PlayerData.player_stats["ShipLvl"]["Value"])
	money_label.text = str(PlayerData.player_stats["Money"]["Value"])
	time_label.text = str(PlayerData.player_stats["TimeUsed"]["Value"]) + " Weeks Used, " + str(52 - PlayerData.player_stats["TimeUsed"]["Value"]) + " Remaining"
