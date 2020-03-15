extends Spatial

var player : Spatial

func is_space_free(position : Vector2) -> bool:
	for object in get_tree().get_nodes_in_group("board_object"):
		if object.board_position == position and object.is_solid():
			return false
	return true

func is_water_at(position : Vector2) -> bool:
	for object in get_tree().get_nodes_in_group("board_object"):
		if object.board_position == position and object is Water:
			return true
	return false

func player_turn_finished() -> void:
	get_tree().call_group("board_object", "tick")
	player.can_move = true
