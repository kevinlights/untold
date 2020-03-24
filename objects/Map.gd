extends Control

const TILESET = preload("res://textures/map_tileset.png")

const TILE_SIZE : Vector2 = Vector2(4, 4)

var map : Image
var player_position : Vector2

func _draw() -> void:
	for x in range(0, GameSession.MAP_SIZE.x):
		for y in range(0, GameSession.MAP_SIZE.y):
			var position : Vector2 = Vector2(x, y)
			if GameSession.is_map_explored(position):
				var c : Color = map.get_pixel(x, y)
				var t : Vector2 = Vector2(0, 0)
				match c:
					LevelBuilder.COLOUR_WALL:
						t = Vector2(1, 0)
					LevelBuilder.COLOUR_WEAK_WALL:
						t = Vector2(1, 0)
					LevelBuilder.COLOUR_WATER:
						t = Vector2(3, 0)
					LevelBuilder.COLOUR_WATER_TUNNEL:
						t = Vector2(3, 0)
					LevelBuilder.COLOUR_DOOR:
						t = Vector2(2, 0)
					LevelBuilder.COLOUR_LOCKED_DOOR:
						t = Vector2(2, 0)
				draw_texture_rect_region(TILESET, Rect2(position * TILE_SIZE, TILE_SIZE), Rect2(t * TILE_SIZE, TILE_SIZE))
	draw_texture_rect_region(TILESET, Rect2(player_position * TILE_SIZE, TILE_SIZE), Rect2(Vector2(0, 1) * TILE_SIZE, TILE_SIZE))

func set_map(map : Image) -> void:
	self.map = map
