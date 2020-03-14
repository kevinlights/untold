extends Spatial

onready var camera = $Camera

var board_position : Vector2
var facing : float
var underwater : bool
var can_move : bool

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		board_position -= Vector2(sin(deg2rad(facing)), cos(deg2rad(facing)))
	if event.is_action_pressed("ui_down"):
		board_position += Vector2(sin(deg2rad(facing)), cos(deg2rad(facing)))
	if event.is_action_pressed("ui_left"):
		facing += 90.0
	if event.is_action_pressed("ui_right"):
		facing -= 90.0
	if event.is_action_pressed("ui_page_down"):
		camera.translation.y = -0.1
	if event.is_action_pressed("ui_page_up"):
		camera.translation.y = 0.5

func _process(delta : float) -> void:
	rotation_degrees.y = lerp(rotation_degrees.y, facing, delta * 20.0)
	translation.x = lerp(translation.x, board_position.x, delta * 20.0)
	translation.z = lerp(translation.z, board_position.y, delta * 20.0)

func _ready() -> void:
	facing = 0.0
	board_position = Vector2(translation.x, translation.z)
