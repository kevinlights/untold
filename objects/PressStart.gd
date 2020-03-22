extends HBoxContainer

onready var icon_hand = $Icon_Hand

func _process(delta : float) -> void:
	var time : float = OS.get_ticks_msec() / 1000.0
	icon_hand.rect_position.y = (sin(time * 4.0) * 4.0)
