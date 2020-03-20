extends Node

var health : int
var level : int
var treasure_collected : int
var keys : int
var bombs : int
var got_map : bool
var glyphs_collected : Array

func new_game() -> void:
	health = 3
	level = 0
	treasure_collected = 0
	keys = 0
	bombs = 0
	got_map = false
	glyphs_collected = [false, false, false, false]

func _ready() -> void:
	new_game()
