extends Node

onready var blackout = $CanvasLayer/Blackout
onready var music = $Audio_Music
onready var audio_start = $Audio_Start
onready var demo = $TitleDemo
onready var tween = $Tween
onready var timer_reset_demo = $Timer_ResetDemo

var fading_out : bool = false

func _input(event : InputEvent) -> void:
	if fading_out: return
	if event.is_action_pressed("start"):
		fading_out = true
		audio_start.play()
		tween.interpolate_property(blackout, "color", blackout.color, Color.black, 1.0)
		tween.interpolate_property(music, "volume_db", 0.0, -80.0, 2.0)
		tween.start()
		yield(tween, "tween_all_completed")
		yield(get_tree().create_timer(2.0), "timeout")
		GameSession.new_game()
		get_tree().change_scene("res://scenes/Game.tscn")

func _on_Timer_ResetDemo_timeout() -> void:
	tween.interpolate_property(blackout, "color", Color(0.0, 0.0, 0.0, 0.0), Color.black, 2.0)
	tween.start()
	yield(tween, "tween_all_completed")
	demo.reset_camera()
	if not fading_out:
		tween.interpolate_property(blackout, "color", Color.black, Color(0.0, 0.0, 0.0, 0.0), 2.0)
		tween.start()

func _ready() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	music.play()
	tween.interpolate_property(blackout, "color", Color.black, Color(0.0, 0.0, 0.0, 0.0), 0.5)
	tween.start()
	timer_reset_demo.start()
