extends Node

class_name Job

var money_reward = 0
var cargo_space = 0
var destination = null

func _init(reward, cargo_space, destination):
	self.money_reward = reward
	self.cargo_space = cargo_space
	self.destination = destination
