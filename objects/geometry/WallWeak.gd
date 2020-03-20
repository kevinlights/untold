extends "res://objects/geometry/BoardObject.gd"

func is_solid() -> bool:
	return true

func is_sight_blocker() -> bool:
	return true

func is_destructible() -> bool:
	return true

func destroy() -> void:
	queue_free()
