extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D
onready var audio_hum = $Audio_Hum
onready var audio_get = $Audio_Get
onready var light_arm_a = $LightArmA
onready var light_arm_b = $LightArmB

onready var collected : bool = false

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

func _process(delta : float) -> void:
	var time : float = OS.get_ticks_msec() / 1000.0
	sprite.translation.y = 0.5 + (sin(time * 2.0) * 0.05)
	var frame : int = int(fmod(time * 10.0, 36.0))
	sprite.frame_coords = Vector2(frame, GameSession.level)
	light_arm_a.rotate_x(delta * 0.5)
	light_arm_a.rotate_y(delta * 1.2)
	light_arm_a.rotate_z(delta * 2.0)
	light_arm_b.rotate_x(delta * 0.2)
	light_arm_b.rotate_y(delta * 0.6)
	light_arm_b.rotate_z(delta * 0.9)

func _ready() -> void:
	audio_hum.play()
