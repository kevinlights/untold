extends Spatial

onready var light = $OmniLight

func _process(delta : float) -> void:
	var time : float = OS.get_ticks_msec() / 1000.0
	light.light_energy = 1 + (sin(time * 2.0) * 0.5)
