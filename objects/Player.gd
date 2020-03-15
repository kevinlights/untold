extends "res://objects/geometry/BoardObject.gd"

class_name Player

onready var camera = $Camera

var facing : float
var underwater : bool
var can_move : bool

func finish_turn() -> void:
	can_move = false
	level.player_turn_finished()

func move(destination : Vector2) -> void:
	if level.is_space_free(destination):
		board_position = destination
		finish_turn()

func try_to_interact(position : Vector2) -> void:
	for object in get_tree().get_nodes_in_group("board_object"):
		if object.is_interactive() and object.board_position == position:
			object.interact()
			finish_turn()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		move(board_position - Vector2(sin(deg2rad(facing)), cos(deg2rad(facing))))
	if event.is_action_pressed("ui_down"):
		move(board_position + Vector2(sin(deg2rad(facing)), cos(deg2rad(facing))))
	if event.is_action_pressed("ui_left"):
		facing += 90.0
	if event.is_action_pressed("ui_right"):
		facing -= 90.0
	if event.is_action_pressed("ui_page_down"):
		camera.translation.y = -0.1
	if event.is_action_pressed("ui_page_up"):
		camera.translation.y = 0.5
	if event.is_action_pressed("ui_select"):
		try_to_interact(board_position - Vector2(sin(deg2rad(facing)), cos(deg2rad(facing))))

func _process(delta : float) -> void:
	rotation_degrees.y = lerp(rotation_degrees.y, facing, delta * 20.0)
	translation.x = lerp(translation.x, board_position.x, delta * 20.0)
	translation.z = lerp(translation.z, board_position.y, delta * 20.0)

func _ready() -> void:
	facing = 0.0
	board_position = Vector2(translation.x, translation.z)
