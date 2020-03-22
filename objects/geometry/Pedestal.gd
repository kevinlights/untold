extends "res://objects/geometry/BoardObject.gd"

onready var mesh = $Mesh
onready var tween = $Tween
onready var sprite_glyph = $Sprite_Glyph
onready var light = $OmniLight
onready var audio_hum = $Audio_Hum

var which_glyph : int
onready var has_glyph : bool = false

func is_solid() -> bool:
	return true

func is_sight_blocker() -> bool:
	return is_solid()

func is_interactive() -> bool:
	return true

func put_glyph() -> void:
	sprite_glyph.show()
	light.show()
	audio_hum.play()
	has_glyph = true

func interact() -> void:
	if not has_glyph and GameSession.glyphs_collected[which_glyph]:
		put_glyph()

func _process(delta : float) -> void:
	var time : float = OS.get_ticks_msec() / 1000.0
	sprite_glyph.translation.y = 0.6 + (sin((time * 2.0) + which_glyph) * 0.05)
	light.light_energy = 1 + (sin((time * 5.0) + which_glyph) * 0.5)
	var frame : int = int(fmod(time * 10.0, 36.0))
	sprite_glyph.frame_coords.x = frame

func set_glyph(which : int) -> void:
	which_glyph = which
	sprite_glyph.frame_coords.y = which_glyph
	match which:
		0: audio_hum.pitch_scale = 0.5
		1: audio_hum.pitch_scale = 1.0
		2: audio_hum.pitch_scale = 2.0
