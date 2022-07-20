extends "res://objects/geometry/BoardObject.gd"

class_name Player

const OBJ_BOMB = preload("res://objects/Bomb.tscn")

onready var camera = $Camera
onready var audio_step = $Audio_Step
onready var audio_swim = $Audio_Swim
onready var audio_splash = $Audio_Splash
onready var audio_leave_water = $Audio_LeaveWater
onready var tween : Tween = $Tween

onready var step_audio : Array = [
	preload("res://audio/player_step1.ogg"),
	preload("res://audio/player_step2.ogg"),
	preload("res://audio/player_step3.ogg"),
	preload("res://audio/player_step4.ogg")
]

var facing : float
var underwater : bool
var can_move : bool

func is_moving() -> bool:
	return tween.is_active()

func get_facing_vector() -> Vector2:
	return Vector2.UP.rotated(-facing)

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
			tween.interpolate_property(camera, "translation", camera.translation, Vector3(0.0, 0.5, -0.1), 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)
			audio_leave_water.play()
			moved = true
			underwater = false
	else:
		if level.is_water_at(destination):
			board_position = destination
			tween.interpolate_property(camera, "translation", camera.translation, Vector3(0.0, -0.1, -0.1), 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)
			audio_splash.play()
			underwater = true
			moved = true
		elif level.is_space_free(destination):
			board_position = destination
			audio_step.stream = step_audio[GameSession.steps_taken % step_audio.size()]
			audio_step.play()
			moved = true
	if moved:
		tween.interpolate_property(self, "translation", translation, Vector3(board_position.x, translation.y, board_position.y), 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.start()
		finish_turn()
		GameSession.steps_taken += 1

func turn(change : float) -> void:
	facing += change
	tween.interpolate_property(self, "rotation", rotation, Vector3(0.0, facing, 0.0), 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
	get_tree().call_group("board_object", "update_angle", facing)
	get_tree().call_group("ui", "update_ui")

func can_interact() -> bool:
	var position : Vector2 = board_position + get_facing_vector()
	for object in get_tree().get_nodes_in_group("board_object"):
		if object.is_interactive() and object.board_position == position:
			return true
	return false

func try_to_interact(position : Vector2) -> void:
	for object in get_tree().get_nodes_in_group("board_object"):
		if object.is_interactive() and object.board_position == position:
			object.interact()
			finish_turn()

func plant_bomb() -> void:
	if GameSession.bombs <= 0:
		return
	var bomb : Spatial = OBJ_BOMB.instance()
	var candidate_position : Vector2 = board_position
	if level.is_space_free(board_position + get_facing_vector()):
		candidate_position += get_facing_vector()
	bomb.board_position = candidate_position
	bomb.translation = Vector3(
		candidate_position.x + (get_facing_vector().x / 3.0), 0.0,
		candidate_position.y + (get_facing_vector().y / 3.0)
	)
	bomb.level = level
	level.add_child(bomb)
	bomb.light()
	GameSession.bombs -= 1
	finish_turn()

func _input(event : InputEvent) -> void:
	if is_moving() or !can_move:
		return
	if event.is_action_pressed("interact"):
		try_to_interact(board_position + get_facing_vector())
	if event.is_action_pressed("bomb"):
		plant_bomb()
	if event.is_action_pressed("toggle_map"):
		if GameSession.got_map:
			var ui = get_tree().get_nodes_in_group("ui")[0]
			ui.map.visible = !ui.map.visible

func _physics_process(delta : float) -> void:
	if is_moving() or !can_move:
		return
	if Input.is_action_pressed("move_forwards"):
		move(board_position + get_facing_vector())
	if Input.is_action_pressed("move_backwards"):
		move(board_position - get_facing_vector())
	if Input.is_action_pressed("turn_left"):
		turn(PI / 2.0)
	if Input.is_action_pressed("turn_right"):
		turn(-PI / 2.0)

func _ready() -> void:
	facing = 0.0
	rotation_degrees.y = 0.0
	board_position = Vector2(translation.x, translation.z)
	get_tree().call_group("board_object", "update_angle", facing)
