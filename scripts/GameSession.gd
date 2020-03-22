extends Node

const MAP_SIZE : Vector2 = Vector2(32, 32)

var health : int
var level : int
var treasure_collected : int
var keys : int
var bombs : int
var got_map : bool
var glyphs_collected : Array
var map_filled : BitMap
onready var use_shader : bool = true

func clear_map() -> void:
	map_filled = BitMap.new()
	map_filled.create(MAP_SIZE)

func set_map_explored(position : Vector2) -> void:
	map_filled.set_bit_rect(Rect2(position - Vector2.ONE, Vector2(3, 3)), true)
	#map_filled.set_bit(position, true)

func is_map_explored(position : Vector2) -> bool:
	return map_filled.get_bit(position)

func new_game() -> void:
	health = 3
	level = 0
	treasure_collected = 0
	keys = 0
	bombs = 0
	got_map = false
	glyphs_collected = [false, false, false, false]
	clear_map()

func enter_level() -> void:
	treasure_collected = 0
	got_map = false
	clear_map()

func _ready() -> void:
	new_game()
