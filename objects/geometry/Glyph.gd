extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D
onready var audio_hum = $Audio_Hum
onready var audio_get = $Audio_Get
onready var anim_player_float : AnimationPlayer = $AnimationPlayer_Float
onready var anim_player_lights : AnimationPlayer = $AnimationPlayer_Lights

onready var collected : bool = false
var frame : int = 0

func is_solid() -> bool:
	return false

func is_interactive() -> bool:
	return false

func tick() -> void:
	if collected: return
	if level.get_player().board_position == board_position:
		audio_hum.stop()
		audio_get.play()
		collected = true
		hide()
		GameSession.glyphs_collected[GameSession.level] = true

func _on_Timer_NextFrame_timeout() -> void:
	frame = (frame + 1) % 36
	sprite.frame_coords = Vector2(frame, GameSession.level)

func _ready() -> void:
	audio_hum.play()
	anim_player_float.play("float")
	anim_player_lights.play("glyph_lights")
