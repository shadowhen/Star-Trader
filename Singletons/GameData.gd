extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var planet_inventory = {}
var item_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	restart()

func restart():
	var item_data_file = File.new()
	item_data_file.open("res://Data/gameData.json", File.READ)
	var item_data_json = JSON.parse(item_data_file.get_as_text())
	item_data_file.close()
	item_data = item_data_json.result
	
	var planet_data_file = File.new()
	planet_data_file.open("res://Data/planetInventory.json", File.READ)
	var planet_data_json = JSON.parse(planet_data_file.get_as_text())
	planet_data_file.close()
	planet_inventory = planet_data_json.result
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
