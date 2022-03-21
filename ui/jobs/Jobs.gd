extends Control

onready var left_side = $Container/Left
onready var right_side = $Container/Right

onready var job_template = preload("res://ui/jobs/JobTemplate.tscn")

var current_planet = null

signal job_taken

func _ready():
	PlayerData.connect("job_removed", self, "_on_job_removed")

func setup(planet):
	current_planet = planet
	
	clear_available_jobs()
	for job in planet.available_jobs:
		add_available_job(job)

func clear_available_jobs():
	var children = left_side.get_children()
	for child in children:
		left_side.remove_child(child)
		child.queue_free()


func add_available_job(job : Job):
	var available_job = job_template.instance()
	available_job.setup(job)
	left_side.add_child(available_job)
	
	available_job.connect("take_job", self, "_on_take_job")


func _on_take_job(job):
	var current_job = job.current_job
	var new_cargo_space = PlayerData.inventory_space + current_job.cargo_space
	
	# Break if player does not have enough space for cargo
	if new_cargo_space > PlayerData.inventory_cap:
		GlobalSignals.annouce_message("Not enough cargo space for a job")
		return
	
	# Move job to the right side
	left_side.remove_child(job)
	right_side.add_child(job)
	
	# Disconnect and remove "take job" button
	job.disconnect("take_job", self, "_on_take_job")
	job.disable_button()
	
	# Store the job into the player's job log
	PlayerData.job_log.push_back(job.current_job)
	
	if current_planet != null:
		current_planet.available_jobs.erase(job.current_job)
	
	emit_signal("job_taken")
	GlobalSignals.update_info()

func _on_job_removed(job):
	if job.destination != current_planet:
		return
	
	PlayerData.money += job.money_reward
	for child in right_side.get_children():
		if child.current_job == job:
			right_side.remove_child(child)
			child.queue_free()
			GlobalSignals.update_info()
			break
