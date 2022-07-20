extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D
onready var light = $OmniLight
onready var anim_player : AnimationPlayer = $AnimationPlayer

func is_solid() -> bool:
	return true

func _ready() -> void:
	anim_player.play("light")
