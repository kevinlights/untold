extends "res://objects/geometry/BoardObject.gd"

const BOREDOM_THRESHOLD : int = 5

enum STATE { IDLE, CHASE, PURSUE, LOOKOUT, RETURN_TO_IDLE, DEAD}

var facing : Vector2
var state : int
var target : Spatial # What are we chasing?
var target_position : Vector2 # The board position of the monster's target when it was last seen
var boredom : int # How long since we last saw the thing we're chasing

func can_see_position(position : Vector2) -> bool:
	var sight_position : Vector2 = board_position + facing
	while true:
		if position == sight_position:
			return true
		if level.is_space_sight_blocked(sight_position):
			return false
		sight_position += facing
	return false

func can_see_object(object : Spatial) -> bool:
	var object_position : Vector2 = object.board_position
	return can_see_position(object_position)

func check_for_targets() -> void:
	# The monster's first priority is the player
	var player : Spatial = level.get_player()
	if can_see_object(player):
		target = player
		boredom = 0
		state = STATE.CHASE
		print("DEBUG: Monster has seen player, entering chase mode")

func move(direction : Vector2) -> void:
	var destination : Vector2 = board_position + direction
	if level.is_space_free(destination):
		board_position = destination
		facing = direction
		# TODO: animate this a bit
	else:
		print("WARN: Enemy couldn't move to intended destination")

func idle() -> void:
	check_for_targets()

func chase() -> void:
	# Can we still see the target?
	if can_see_object(target):
		target_position = target.board_position
		var route = level.get_route(board_position, target_position)
		# Make sure we actually have a route to the target
		if route != null:
			# If we're next to the target, smack 'em!
			if route.size() == 1:
				pass # TODO
			# Can we find a route to the target? 
			elif route.size() > 1:
				# Step towards the target
				var next_step : Vector2 = route[0]
				move(next_step)
			# Well, if it isn't 1, and it isn't greater than 1...
			elif route.size() == 0:
				print("WARN: Target is invading enemy's personal bubble!")
		# We... can't find the target? How!?
		else:
			print("WARN: Enemy has line of sight to target, but can't find route.")
	# We've lost sight of the target: move to their last known position
	else:
		state = STATE.PURSUE
		print("DEBUG: Monster has lost sight of player, entering pursue mode")

# For when a target has recently moved out of sight
func pursue() -> void:
	# Have we found the target again?
	if can_see_object(target):
		pass
	else:
		# Get the route to the target's last known position
		var route = level.get_route(board_position, target_position)
		# Do we actually have a route to that position?
		if route != null:
			# Have we already reached the position?
			if route.size() == 0:
				# Reached the position - stay a while
				state = STATE.LOOKOUT
				boredom = 0
			# We're not at the position yet - keep moving!
			else:
				var next_step : Vector2 = route[0]
				move(next_step)
		# We can't go to that position...
		else:
			pass

# We've reached the target's last known position - wait around a bit
func lookout() -> void:
	# Have we found the target again?
	if can_see_object(target):
		pass
	else:
		boredom += 1
		if boredom >= BOREDOM_THRESHOLD:
			# Transition to idle
			state = STATE.IDLE

func update_position() -> void:
	translation = Vector3(board_position.x, 0, board_position.y)

func is_solid() -> bool:
	return true

func tick() -> void:
	match state:
		STATE.IDLE:
			idle()
		STATE.CHASE:
			chase()
		STATE.PURSUE:
			pursue()
		STATE.LOOKOUT:
			lookout()
	update_position()

func _ready() -> void:
	facing = Vector2.DOWN
	state = STATE.IDLE
