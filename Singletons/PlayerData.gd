extends Node

signal job_removed(job)
signal money_update(value)

var inv_data = {}
var player_stats = {}

var job_log = []
var money setget set_money, get_money
var time_used setget set_time_used, get_time_used
var inventory_space setget , get_inventory_space
var inventory_cap setget set_inventory_cap, get_inventory_cap

# Called when the node enters the scene tree for the first time.
func _ready():
	restart()


func restart():
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


func set_money(p_money : int) -> void:
	PlayerData.player_stats["Money"]["Value"] = p_money
	emit_signal("money_update", p_money)

func get_money() -> int:
	return int(PlayerData.player_stats["Money"]["Value"])

func set_time_used(p_time_used : int) -> void:
	PlayerData.player_stats["TimeUsed"]["Value"] = p_time_used

func get_time_used() -> int:
	return int(PlayerData.player_stats["TimeUsed"]["Value"])

func get_inventory_space() -> int:
	var inventory_space_used = 0
	
	# Loop through the inventory and increment space if item id is valid
	for i in PlayerData.inv_data.keys():
		var itemID = PlayerData.inv_data[i]["InvItemID"]
		if itemID != -1:
			inventory_space_used += 1
	
	# Loop through the job log and increase space based on the job's
	# cargo space
	for job in job_log:
		inventory_space_used += job.cargo_space
	
	return inventory_space_used

func set_inventory_cap(p_inventory_cap) -> void:
	PlayerData.player_stats["InventoryCap"]["Value"] = p_inventory_cap

func get_inventory_cap() -> int:
	return int(PlayerData.player_stats["InventoryCap"]["Value"])

func remove_job(job : Job):
	if job_log.has(job):
		job_log.erase(job)
		emit_signal("job_removed", job)
