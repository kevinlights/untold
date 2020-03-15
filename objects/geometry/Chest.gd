extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D
onready var audio_open = $Audio_Open

onready var open : bool = false

func is_solid() -> bool:
	return true

func is_interactive() -> bool:
	return true

func interact() -> void:
	if open: return
	audio_open.play()
	open = true
	sprite.frame = 1
