extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D
onready var audio_get = $Audio_Get

onready var collected : bool = false

func is_solid() -> bool:
	return false

func is_interactive() -> bool:
	return false

func tick() -> void:
	if collected: return
	if level.get_player().board_position == board_position:
		audio_get.play()
		collected = true
		hide()
		GameSession.glyphs_collected[GameSession.level] = true

func _process(delta : float) -> void:
	var time : float = OS.get_ticks_msec() / 1000.0
	sprite.translation.y = 0.5 + (sin(time * 2.0) * 0.05)
