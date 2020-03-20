extends Spatial

var board_position : Vector2
var level : Spatial

func is_solid() -> bool:
	return false

func is_sight_blocker() -> bool:
	return false

func is_interactive() -> bool:
	return false

func is_destructible() -> bool:
	return false

func interact() -> void:
	pass

func destroy() -> void:
	pass

func tick() -> void:
	pass
