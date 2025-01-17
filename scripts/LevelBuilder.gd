extends Node

const OBJ_FLOOR = preload("res://objects/geometry/FloorCeiling.tscn")
const OBJ_FLOOR_HIGH_CEILING = preload("res://objects/geometry/FloorHighCeiling.tscn")
const OBJ_WALL = preload("res://objects/geometry/Wall.tscn")
const OBJ_WATER = preload("res://objects/geometry/Water.tscn")
const OBJ_PLAYER = preload("res://objects/geometry/Player.tscn")
const OBJ_TORCH = preload("res://objects/geometry/Torch.tscn")
const OBJ_DOOR = preload("res://objects/geometry/Door.tscn")
const OBJ_CHEST = preload("res://objects/geometry/Chest.tscn")
const OBJ_MONSTER = preload("res://objects/geometry/Monster.tscn")
const OBJ_LOCKED_DOOR = preload("res://objects/geometry/LockedDoor.tscn")
const OBJ_KEY = preload("res://objects/geometry/Key.tscn")
const OBJ_LEVEL_EXIT = preload("res://objects/geometry/LevelExit.tscn")
const OBJ_WEAK_WALL = preload("res://objects/geometry/WallWeak.tscn")
const OBJ_GLYPH = preload("res://objects/geometry/Glyph.tscn")
const OBJ_MAP = preload("res://objects/geometry/Map.tscn")
const OBJ_PEDESTAL = preload("res://objects/geometry/Pedestal.tscn")
const OBJ_STATUE = preload("res://objects/geometry/Statue.tscn")
const OBJ_INVISIBLE_WALL = preload("res://objects/geometry/InvisibleWall.tscn")
const OBJ_INVISIBLE_WALL_HIGH_CEILING = preload("res://objects/geometry/InvisibleWallHighCeiling.tscn")

func place_object(type, x : int, y : int, destination : Spatial) -> Spatial:
	var o = type.instance()
	o.translation.x = x
	o.translation.z = y
	o.board_position = Vector2(x, y)
	o.level = destination
	destination.add_child(o)
	if o is Player:
		destination.player = o
	return o

func setup_level(map : Image, destination : Spatial) -> void:
	destination.map = map
	var glyph_count : int = 0
	for x in map.get_size().x:
		for y in map.get_size().y:
			var c : Color = map.get_pixel(x, y)
			match c:
				Constants.COLOUR_WALL:
					place_object(OBJ_WALL, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_FLOOR:
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_FLOOR_HIGH_CEILING:
					place_object(OBJ_FLOOR_HIGH_CEILING, x, y, destination)
				Constants.COLOUR_WATER:
					place_object(OBJ_WATER, x, y, destination)
				Constants.COLOUR_WATER_TUNNEL:
					place_object(OBJ_WALL, x, y, destination)
					place_object(OBJ_WATER, x, y, destination)
				Constants.COLOUR_PLAYER_START:
					place_object(OBJ_PLAYER, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_TORCH:
					place_object(OBJ_TORCH, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_TREASURE:
					place_object(OBJ_FLOOR, x, y, destination)
					var chest : Spatial = place_object(OBJ_CHEST, x, y, destination)
					chest.contents = Chest.CONTENTS.SCORE
					GameSession.treasure_in_level += 1
				Constants.COLOUR_MONSTER:
					place_object(OBJ_MONSTER, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_DOOR:
					place_object(OBJ_DOOR, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_LOCKED_DOOR:
					place_object(OBJ_LOCKED_DOOR, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_KEY:
					place_object(OBJ_KEY, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_LEVEL_EXIT:
					place_object(OBJ_LEVEL_EXIT, x, y, destination)
				Constants.COLOUR_WEAK_WALL:
					place_object(OBJ_WEAK_WALL, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_CHEST_WITH_BOMBS:
					place_object(OBJ_FLOOR, x, y, destination)
					var chest : Spatial = place_object(OBJ_CHEST, x, y, destination)
					chest.contents = Chest.CONTENTS.BOMBS
					GameSession.treasure_in_level += 1
				Constants.COLOUR_GLYPH:
					place_object(OBJ_GLYPH, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_MAP:
					place_object(OBJ_MAP, x, y, destination)
					place_object(OBJ_FLOOR, x, y, destination)
				Constants.COLOUR_PEDESTAL:
					place_object(OBJ_FLOOR_HIGH_CEILING, x, y, destination)
					var pedestal : Spatial = place_object(OBJ_PEDESTAL, x, y, destination)
					pedestal.set_glyph(glyph_count)
					glyph_count += 1 # janky hack m8
				Constants.COLOUR_STATUE:
					place_object(OBJ_STATUE, x, y, destination)
					place_object(OBJ_FLOOR_HIGH_CEILING, x, y, destination)
				Constants.COLOUR_INVISIBLE_WALL:
					place_object(OBJ_INVISIBLE_WALL, x, y, destination)
				Constants.COLOUR_INVISIBLE_WALL_HIGH_CEILING:
					place_object(OBJ_INVISIBLE_WALL_HIGH_CEILING, x, y, destination)
	for door in get_tree().get_nodes_in_group("door"):
		door.set_orientation()

func load_map(map : Image, destination : Spatial) -> void:
	setup_level(map, destination)
