extends Spatial

const OBJ_WALL_BROKEN = preload("res://objects/geometry/WallBroken.tscn")

const MAX_ROUTE_DEPTH : int = 32

var player : Spatial
var map : Image

var override_game : bool = false

func get_player() -> Spatial:
	return player

func is_space_free(position : Vector2) -> bool:
	# First, check for blockers that don't move
	if map.get_pixelv(position) in Constants.STATIC_BLOCKERS:
		return false
	# Now check for a dynamic blocker
	for object in get_tree().get_nodes_in_group("dynamic_blocker"):
		if object.board_position == position and object.is_solid():
			return false
	return true

# Returns whether or not the given location has something at it that blocks light (i.e. a wall)
func is_space_sight_blocked(position : Vector2) -> bool:
	for object in get_tree().get_nodes_in_group("board_object"):
		if object.board_position == position and object.is_sight_blocker():
			return true
	return false

func is_water_at(position : Vector2) -> bool:
	return map.get_pixelv(position) in Constants.WATER_CELLS

class Route:
	var steps : Array
	var distance : int
	var destination : Vector2
	
	func _init(steps : Array, distance : int, destination : Vector2):
		self.steps = steps
		self.distance = distance
		self.destination = destination

func get_route(from : Vector2, to : Vector2):
	var pending : Array = [
		Route.new([], 0, from)
	]
	var checked : Array = []
	while true:
		# Chose the shortest route in the pending list
		var shortest_route : Route
		var shortest_distance : int = 999
		for route in pending:
			if route.distance < shortest_distance:
				shortest_route = route
				shortest_distance = route.distance
		# We did just find a route, right?
		if shortest_distance == 999:
			# Nope! Give up.
			return null
		# Did we just land on a route to the destination?
		if shortest_route.destination == to:
			return shortest_route.steps
		# Check all the spaces we can reach from this position
		for offset in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
			var candidate : Vector2 = shortest_route.destination + offset
			if is_space_free(candidate) and not checked.has(candidate):
				var new_steps : Array = shortest_route.steps.duplicate()
				new_steps.append(offset)
				pending.append(Route.new(new_steps, shortest_distance + 1, candidate))
		# We're done with this route - remove it from the list
		pending.remove(pending.find(shortest_route))
		checked.append(shortest_route.destination)

func fill_map(position : Vector2) -> void:
	GameSession.set_map_explored(position)
	for offset in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT,
					Vector2(-1, -1), Vector2(-1, 1), Vector2(1, -1), Vector2(1, 1)]:
		if not is_space_sight_blocked(position + offset):
			GameSession.set_map_explored(position + offset)
			# And if we can see _this_ tile, let's go further
			if not is_space_sight_blocked(position + offset + offset):
				GameSession.set_map_explored(position + offset + offset)

func player_turn_finished() -> void:
	get_tree().call_group("board_object", "tick")
	if not is_level_finished():
		get_tree().call_group("ui", "update_ui")
		fill_map(get_player().board_position)
		player.can_move = true
	else:
		do_level_outro()

func is_level_finished() -> bool:
	for exit in get_tree().get_nodes_in_group("level_exit"):
		if exit.board_position == get_player().board_position:
			return true
	return false

func do_level_outro() -> void:
	get_parent().fade_out_ambience()
	get_tree().call_group("ui", "fade_out")
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://scenes/LevelClear.tscn")

func make_explosion(position : Vector2) -> void:
	for weak_wall in get_tree().get_nodes_in_group("wall_weak"):
		for offset in [Vector2.ZERO, Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
			if weak_wall.board_position == position + offset:
				weak_wall.destroy()
				var debris : Spatial = OBJ_WALL_BROKEN.instance()
				debris.board_position = weak_wall.board_position
				debris.translation = weak_wall.translation
				add_child(debris)
				debris.do_break()

func start_level() -> void:
	get_player().can_move = true
