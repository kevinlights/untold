extends "res://objects/geometry/BoardObject.gd"

onready var mesh = $Mesh
onready var tween = $Tween
onready var audio_open = $Audio_Open
onready var audio_close = $Audio_Close

var open : bool
var turns_to_close : int

func set_orientation() -> void:
	if level.is_space_free(board_position + Vector2.LEFT) and level.is_space_free(board_position + Vector2.RIGHT):
		mesh.rotation_degrees.y = 90.0

func is_solid() -> bool:
	return not open

func is_interactive() -> bool:
	return true

func interact() -> void:
	if not open:
		open()
	else:
		close()

func open() -> void:
	tween.interpolate_property(mesh, "translation", Vector3(0.0, 0.5, 0.0), Vector3(0.0, 1.35, 0.0), 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
	audio_open.play()
	open = true
	turns_to_close = 4

func close() -> void:
	tween.interpolate_property(mesh, "translation", Vector3(0.0, 1.35, 0.0), Vector3(0.0, 0.5, 0.0), 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
	audio_close.play()
	open = false

func tick() -> void:
	if open:
		turns_to_close -= 1
		if turns_to_close <= 0:
			close()
