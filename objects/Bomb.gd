extends "res://objects/geometry/BoardObject.gd"

const OBJ_EXPLOSION = preload("res://objects/Explosion.tscn")

onready var sprite = $Sprite3D
onready var audio_wick = $Audio_Wick
onready var tween = $Tween

var turns_to_explosion : int

func light() -> void:
	tween.interpolate_property(sprite, "translation", Vector3(0, 0.5, 0), Vector3.ZERO, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	audio_wick.play()
	turns_to_explosion = 4

func explode() -> void:
	level.make_explosion(board_position)
	var explosion : Spatial = OBJ_EXPLOSION.instance()
	level.add_child(explosion)
	explosion.translation = translation + Vector3(0.0, 0.5, 0.0)
	explosion.explode()
	queue_free()

func tick() -> void:
	turns_to_explosion -= 1
	if turns_to_explosion <= 0:
		explode()
