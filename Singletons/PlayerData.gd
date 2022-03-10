extends Node

var inv_data = {}
var player_stats = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# parses inventory data
	var inv_data_file = File.new()
	inv_data_file.open("res://Data/invData.json", File.READ)
	var inv_data_json = JSON.parse(inv_data_file.get_as_text())
	inv_data_file.close()
	inv_data = inv_data_json.result
	
	# parses player stats
	var stats_data_file = File.new()
	stats_data_file.open("res://Data/playerStats.json", File.READ)
	var stats_data_json = JSON.parse(stats_data_file.get_as_text())
	stats_data_file.close()
	player_stats = stats_data_json.result
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
