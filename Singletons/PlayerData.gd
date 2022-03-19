extends Node

signal job_removed(job)
signal money_update(value)

var inv_data = {}
var player_stats = {}

var job_log = []
var money setget set_money, get_money

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

func set_money(p_money) -> void:
	PlayerData.player_stats["Money"]["Value"] = p_money
	emit_signal("money_update", p_money)

func get_money() -> int:
	return PlayerData.player_stats["Money"]["Value"]

func remove_job(job : Job):
	if job_log.has(job):
		job_log.erase(job)
		emit_signal("job_removed", job)
