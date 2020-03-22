extends Control

const TRACKS = [
	preload("res://music/level_clear1.ogg"),
	preload("res://music/level_clear2.ogg"),
	preload("res://music/level_clear3.ogg")
]

onready var blackout = $Blackout
onready var audio_music = $Audio_Music
onready var tween = $Tween

onready var label_steps_taken = $Stats/StepsTaken/Value
onready var label_treasure_collected = $Stats/Treasure/Value
onready var label_secrets_collected = $Stats/Secrets/Value

onready var level_indicator = $LevelPipe/Indicator

var fading_out : bool = false

func _input(event : InputEvent) -> void:
	if fading_out: return
	if event.is_action_pressed("start"):
		fading_out = true
		tween.interpolate_property(blackout, "color", blackout.color, Color.black, 1.0)
		tween.interpolate_property(audio_music, "volume_db", 0.0, -80.0, 2.0)
		tween.start()
		yield(tween, "tween_all_completed")
		yield(get_tree().create_timer(1.0), "timeout")
		GameSession.level += 1
		GameSession.enter_level()
		get_tree().change_scene("res://scenes/Game.tscn")

func _ready():
	label_steps_taken.text = str(GameSession.steps_taken)
	label_treasure_collected.text = str(GameSession.treasure_collected) + "/" + str(GameSession.treasure_in_level)
	level_indicator.rect_position.x = GameSession.level * 64
	if GameSession.glyphs_collected[GameSession.level] == true:
		label_secrets_collected.text = "1/1"
	yield(get_tree().create_timer(1.0), "timeout")
	tween.interpolate_property(blackout, "color", Color.black, Color(0.0, 0.0, 0.0, 0.0), 1.0)
	tween.interpolate_property(level_indicator, "rect_position", level_indicator.rect_position, level_indicator.rect_position + Vector2(64, 0), 2.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2.5)
	tween.start()
	audio_music.stream = TRACKS[GameSession.level]
	audio_music.play()
