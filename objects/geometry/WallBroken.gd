extends "res://objects/geometry/BoardObject.gd"

onready var audio_break = $Audio_Break

func is_solid() -> bool:
	return false

func is_sight_blocker() -> bool:
	return false

func is_destructible() -> bool:
	return false

func do_break() -> void:
	audio_break.play()
