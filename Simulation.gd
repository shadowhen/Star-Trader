extends Node

# Randomize number of jobs for each planet
func randomize_jobs():
	for planet in _get_planets():
		var num_jobs = randi() % 3
		for i in range(num_jobs):
			var reward = 10 + randi() % 41
			var cargo_space = 1 + randi() % 10
			var destination = _random_find_planet(planet)
			var created_job = Job.new(reward, cargo_space, destination)
			planet.available_jobs.push_back(created_job)


# Clears jobs from all planets
func clear_planet_jobs():
	for planet in _get_planets():
		planet.available_jobs.clear()


# Randomly find a planet that is not the origin
func _random_find_planet(origin):
	var planets =_get_planets()
	
	# Loop until we find a planet that is not the origin
	while true:
		# Randomly pick a planet
		var temp = planets[randi() % len(planets)]
		if temp != origin:
			return temp


func _get_planets():
	return get_tree().get_nodes_in_group("planets")
