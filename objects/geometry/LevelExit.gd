extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D

onready var collected : bool = false

func tick() -> void:
	if collected: return
	if level.get_player().board_position == board_position:
		level.level_clear()

func _process(delta : float) -> void:
	var time : float = OS.get_ticks_msec() / 1000.0
	sprite.translation.y = 0.5 + (sin(time * 2.0) * 0.05)
