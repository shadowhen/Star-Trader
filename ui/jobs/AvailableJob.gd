extends VBoxContainer

signal take_job(job)

var current_job : Job

func setup(job : Job):
	current_job = job
	var format_str = "Deliver %s tons of cargo to %s\nReward: %s monies"
	
	var destination_name
	if current_job.destination == null:
		destination_name = "null"
	else:
		destination_name = current_job.destination.planet_name
	
	var args = [current_job.cargo_space, destination_name, current_job.money_reward]
	$Description.text = format_str % args

func disable_button():
	$Button.hide()
	$Button.disabled = true

func _on_Button_pressed():
	emit_signal("take_job", self)
