extends KinematicBody2D

signal reached_target

export(float) var speed = 250.0

var target_position = Vector2()
var moving = false

# Set the target where the player's ship will go to
func go_to_planet(planet_position):	
	target_position = planet_position
	moving = true
	
	# Rotate the ship where it points towards the planet destination
	look_at(target_position)
	rotate(PI / 2)

func _physics_process(delta):
	var direction_vec = target_position - global_position
	var direction_normal = direction_vec.normalized()
	
	if direction_vec.length() < 5 and moving:
		moving = false
		emit_signal("reached_target")
	elif moving:
		move_and_collide(direction_normal * speed * delta)
