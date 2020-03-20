extends Spatial

const OBJ_WALL_BROKEN = preload("res://objects/geometry/WallBroken.tscn")

const MAX_ROUTE_DEPTH : int = 32

var player : Spatial

func get_player() -> Spatial:
	return player

func is_space_free(position : Vector2) -> bool:
	for object in get_tree().get_nodes_in_group("board_object"):
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
	for object in get_tree().get_nodes_in_group("board_object"):
		if object.board_position == position and object is Water:
			return true
	return false

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

func player_turn_finished() -> void:
	get_tree().call_group("board_object", "tick")
	player.can_move = true

func level_clear() -> void:
	GameSession.level += 1
	get_tree().change_scene("res://scenes/Game.tscn")

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
