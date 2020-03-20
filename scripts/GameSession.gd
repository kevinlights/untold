extends Node

var health : int
var level : int
var keys : int
var bombs : int
var glyphs_collected : Array

func new_game() -> void:
	health = 3
	level = 0
	keys = 0
	bombs = 0
	glyphs_collected = [false, false, false, false]

func _ready() -> void:
	new_game()
