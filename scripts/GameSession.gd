extends Node

var health : int
var level : int
var keys : int

func new_game() -> void:
	health = 3
	level = 0
	keys = 0

func _ready() -> void:
	new_game()
