extends "res://objects/geometry/BoardObject.gd"

onready var mesh = $Mesh
onready var tween = $Tween
onready var audio_open = $Audio_Open
onready var audio_locked = $Audio_Locked

var open : bool
var turns_to_close : int

func set_orientation() -> void:
	if level.is_space_free(board_position + Vector2.LEFT) and level.is_space_free(board_position + Vector2.RIGHT):
		mesh.rotation_degrees.y = 90.0

func is_solid() -> bool:
	return not open

func is_sight_blocker() -> bool:
	return is_solid()

func is_interactive() -> bool:
	return true

func interact() -> void:
	if not open:
		if GameSession.keys > 0:
			open()
			GameSession.keys -= 1
		else:
			audio_locked.play()

func open() -> void:
	tween.interpolate_property(mesh, "translation", Vector3(0.0, 0.5, 0.0), Vector3(0.0, 1.35, 0.0), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	audio_open.play()
	open = true
	turns_to_close = 4
