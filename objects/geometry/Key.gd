extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D
onready var audio_get = $Audio_Get
onready var anim_player : AnimationPlayer = $AnimationPlayer

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
		GameSession.keys += 1

func _ready() -> void:
	anim_player.play("float")
