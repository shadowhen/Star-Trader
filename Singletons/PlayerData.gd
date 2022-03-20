extends Node

signal job_removed(job)
signal money_update(value)

var inv_data = {}
var player_stats = {}

var job_log = []
var money setget set_money, get_money
var time_used setget set_time_used, get_time_used
var inventory_space setget set_inventory_space, get_inventory_space
var inventory_cap setget set_inventory_cap, get_inventory_cap

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

func set_money(p_money : int) -> void:
	PlayerData.player_stats["Money"]["Value"] = p_money
	emit_signal("money_update", p_money)

func get_money() -> int:
	return int(PlayerData.player_stats["Money"]["Value"])

func set_time_used(p_time_used : int) -> void:
	PlayerData.player_stats["TimeUsed"]["Value"] = p_time_used

func get_time_used() -> int:
	return int(PlayerData.player_stats["TimeUsed"]["Value"])

func set_inventory_space(p_inventory_space) -> void:
	PlayerData.player_stats["InventorySpaceUsed"]["Value"] = p_inventory_space

func get_inventory_space() -> int:
	return int(PlayerData.player_stats["InventorySpaceUsed"]["Value"])

func set_inventory_cap(p_inventory_cap) -> void:
	PlayerData.player_stats["InventoryCap"]["Value"] = p_inventory_cap

func get_inventory_cap() -> int:
	return int(PlayerData.player_stats["InventoryCap"]["Value"])

func remove_job(job : Job):
	if job_log.has(job):
		job_log.erase(job)
		emit_signal("job_removed", job)
