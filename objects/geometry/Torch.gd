extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D
onready var light = $OmniLight

func is_solid() -> bool:
	return true

func _process(delta : float) -> void:
	var time : float = OS.get_ticks_msec() / 1000.0
	light.light_energy = 1 + (sin(time * 2.0) * 0.5)
