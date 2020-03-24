extends "res://objects/geometry/BoardObject.gd"

func is_solid() -> bool:
	return true

func is_sight_blocker() -> bool:
	return false

func is_destructible() -> bool:
	return false
