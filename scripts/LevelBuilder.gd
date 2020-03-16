extends Node

const OBJ_FLOOR = preload("res://objects/geometry/FloorCeiling.tscn")
const OBJ_WALL = preload("res://objects/geometry/Wall.tscn")
const OBJ_WATER = preload("res://objects/geometry/Water.tscn")
const OBJ_PLAYER = preload("res://objects/Player.tscn")
const OBJ_TORCH = preload("res://objects/geometry/Torch.tscn")
const OBJ_DOOR = preload("res://objects/geometry/Door.tscn")
const OBJ_CHEST = preload("res://objects/geometry/Chest.tscn")
const OBJ_MONSTER = preload("res://objects/geometry/Monster.tscn")

const COLOUR_FLOOR = Color("000000")
const COLOUR_WALL = Color("595652")
const COLOUR_WATER = Color("306082")
const COLOUR_WATER_TUNNEL = Color("5b6ee1")
const COLOUR_PLAYER_START = Color("4b692f")
const COLOUR_TORCH = Color("fbf236")
const COLOUR_TREASURE = Color("df7126")
const COLOUR_MONSTER = Color("ac3232")
const COLOUR_BOSS = Color("d95763")
const COLOUR_DOOR = Color("8f563b")
const COLOUR_LOCKED_DOOR = Color("663931")
const COLOUR_KEY = Color("eec39a")

func place_object(type, x : int, y : int, destination : Spatial) -> void:
	var o = type.instance()
	o.translation.x = x
	o.translation.z = y
	o.board_position = Vector2(x, y)
	o.level = destination
	destination.add_child(o)
	if o is Player:
		destination.player = o

func setup_level(map : Image, destination : Spatial) -> void:
	for x in map.get_size().x:
		for y in map.get_size().y:
			var c : Color = map.get_pixel(x, y)
			match c:
				COLOUR_WALL:
					place_object(OBJ_WALL, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				COLOUR_FLOOR:
					place_object(OBJ_FLOOR, x, y, destination)
				COLOUR_WATER:
					place_object(OBJ_WATER, x, y, destination)
				COLOUR_WATER_TUNNEL:
					place_object(OBJ_WALL, x, y, destination)
					place_object(OBJ_WATER, x, y, destination)
				COLOUR_PLAYER_START:
					place_object(OBJ_PLAYER, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				COLOUR_TORCH:
					place_object(OBJ_TORCH, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				COLOUR_TREASURE:
					place_object(OBJ_CHEST, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				COLOUR_MONSTER:
					place_object(OBJ_MONSTER, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				COLOUR_DOOR:
					place_object(OBJ_DOOR, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
	for door in get_tree().get_nodes_in_group("door"):
		door.set_orientation()

func load_map(path : String, destination : Spatial) -> void:
	var map : Image = load(path).get_data()
	map.lock()
	setup_level(map, destination)
