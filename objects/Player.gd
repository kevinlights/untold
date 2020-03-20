extends "res://objects/geometry/BoardObject.gd"

class_name Player

const OBJ_BOMB = preload("res://objects/Bomb.tscn")

onready var camera = $Camera
onready var audio_step = $Audio_Step
onready var audio_swim = $Audio_Swim
onready var audio_splash = $Audio_Splash
onready var audio_leave_water = $Audio_LeaveWater

onready var step_audio : Array = [
	preload("res://audio/player_step1.ogg"),
	preload("res://audio/player_step2.ogg"),
	preload("res://audio/player_step3.ogg"),
	preload("res://audio/player_step4.ogg")
]

var facing : float
var underwater : bool
var can_move : bool
var steps_taken : int

func finish_turn() -> void:
	can_move = false
	level.player_turn_finished()

func move(destination : Vector2) -> void:
	var moved : bool = false
	if underwater:
		if level.is_water_at(destination):
			board_position = destination
			audio_swim.play()
			moved = true
		elif level.is_space_free(destination):
			board_position = destination
			audio_leave_water.play()
			moved = true
			underwater = false
	else:
		if level.is_water_at(destination):
			board_position = destination
			audio_splash.play()
			underwater = true
			moved = true
		elif level.is_space_free(destination):
			board_position = destination
			audio_step.stream = step_audio[steps_taken % step_audio.size()]
			audio_step.play()
			moved = true
	if moved:
		finish_turn()
		steps_taken += 1

func try_to_interact(position : Vector2) -> void:
	for object in get_tree().get_nodes_in_group("board_object"):
		if object.is_interactive() and object.board_position == position:
			object.interact()
			finish_turn()

func plant_bomb() -> void:
	if GameSession.bombs <= 0:
		return
	var bomb : Spatial = OBJ_BOMB.instance()
	bomb.translation = translation - (Vector3(sin(deg2rad(facing)), 0.0, cos(deg2rad(facing))) * 0.25)
	bomb.board_position = board_position
	bomb.level = level
	level.add_child(bomb)
	bomb.light()
	GameSession.bombs -= 1
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
	if event.is_action_pressed("ui_select"):
		try_to_interact(board_position - Vector2(sin(deg2rad(facing)), cos(deg2rad(facing))))
	if event.is_action_pressed("bomb"):
		plant_bomb()

func _process(delta : float) -> void:
	rotation_degrees.y = lerp(rotation_degrees.y, facing, delta * 20.0)
	translation.x = lerp(translation.x, board_position.x, delta * 20.0)
	translation.z = lerp(translation.z, board_position.y, delta * 20.0)
	var y_target : float = -0.1 if underwater else 0.5
	camera.translation.y = lerp(camera.translation.y, y_target, delta * 20.0)

func _ready() -> void:
	facing = 0.0
	board_position = Vector2(translation.x, translation.z)
	steps_taken = 0
