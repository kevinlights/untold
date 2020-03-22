extends "res://objects/geometry/BoardObject.gd"

class_name Chest

onready var sprite = $Sprite3D
onready var audio_open = $Audio_Open

enum CONTENTS { SCORE, BOMBS }

var contents

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
	# Give the player the contents
	GameSession.treasure_collected += 1
	if contents == CONTENTS.BOMBS:
		GameSession.bombs += 2
