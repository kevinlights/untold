extends Control

# This entire file is jank. Don't judge me, I was in a hurry.

onready var background = $Background
onready var blackout = $Blackout
onready var message = $Message
onready var label_thankyou = $Label_ThankYou
onready var prompt_press_start = $PressStart
onready var audio_music = $Audio_Music
onready var tween = $Tween

const MESSAGE_A : Array = [
	[13,10,0,4,5,1,18,0,6,18,9,5,14,4],
	[2,10,0,20,8,5,0,20,9,13,5,0,10,15,21,0,18,5,1,4,0,20,8,9,19,0,13,5,19,19,1,7,5,0,17,5,0,17,9,12,12,0,8,1,22,5,0,3,15,13,16,12,5,20,5,4,0,15,21,18,0,18,5,20,18,5,1,20],
	[1,14,4,0,20,8,5,19,5,0,8,1,12,12,15,17,5,4,0,3,8,1,13,2,5,18,19,0,17,9,12,12,0,9,14,0,1,12,12,0,12,9,11,5,12,9,8,15,15,4,0,2,5,0,15,22,5,18,18,21,14],
	[9,0,11,14,15,17,0,20,8,1,20,0,9,20,0,9,19,0,10,15,21,18,0,17,1,10,0,20,15,0,6,18,5,20,0,2,21,20,0,4,15,0,14,15,20,0,17,15,18,18,10,0,6,15,18,0,21,19],
	[2,10,0,10,15,21,18,0,5,6,6,15,18,20,19,0,15,6,0,12,15,14,7,0,1,7,15,0,17,5,0,17,5,18,5,0,1,2,12,5,0,20,15,0,19,5,3,21,18,5,0,15,21,18,19,5,12,22,5,19],
	[1,7,1,9,14,19,20,0,20,8,5,0,19,3,15,21,18,7,5,0,20,8,1,20,0,14,15,17,0,5,14,7,21,12,6,19,0,20,8,9,19,0,17,15,18,12,4],
	[9,20,0,19,1,4,4,5,14,19,0,13,5,0,20,8,1,20,0,15,21,18,0,18,5,21,14,9,15,14,0,13,21,19,20,0,15,14,3,5,0,13,15,18,5,0,2,5,0,4,5,12,1,10,5,4],
	[2,21,20,0,19,8,15,21,12,4,0,17,5,0,14,15,20,0,5,13,5,18,7,5,0,6,18,15,13,0,20,8,9,19,0,4,1,18,11,0,14,9,7,8,20],
	[11,14,15,17,0,20,8,1,20,0,17,5,0,6,1,4,5,4,0,16,5,1,3,5,6,21,12,12,10,0,3,15,14,20,5,14,20,0,9,14,0,20,8,5,0,11,14,15,17,12,5,4,7,5],
	[20,8,1,20,0,20,8,5,0,5,3,8,15,5,19,0,15,6,0,15,21,18,0,20,18,5,1,4,0,1,14,4,0,22,15,9,3,5,0,19,20,9,12,12,0,18,5,19,15,14,1,20,5],
	[9,14,0,8,21,13,2,12,5,0,7,18,1,14,4,17,5,12,12,0,14,15,17,0,19,15,0,6,1,18,0,1,17,1,10]
]

const MESSAGE_B : Array = [
	[20,8,1,14,11,0,10,15,21,0,6,15,18,0,16,12,1,10,9,14,7]
]

var can_quit : bool = false
var fading_out : bool = false

func _input(event : InputEvent) -> void:
	if fading_out: return
	if not can_quit: return
	if event.is_action_pressed("start"):
		fading_out = true
		tween.interpolate_property(blackout, "color", blackout.color, Color.black, 5.0)
		tween.interpolate_property(audio_music, "volume_db", 0.0, -80.0, 5.0)
		tween.start()
		yield(tween, "tween_all_completed")
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://scenes/TitleScreen.tscn")

func _ready() -> void:
	yield(get_tree().create_timer(2.0), "timeout")
	var bus : int = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus, 0)
	message.message = MESSAGE_A
	message.update()
	audio_music.play()
	yield(get_tree().create_timer(1.0), "timeout")
	tween.interpolate_property(message, "modulate", Color.transparent, Color.white, 5.0)
	tween.start()
	yield(get_tree().create_timer(15.0), "timeout")
	tween.interpolate_property(message, "modulate", Color.white, Color.transparent, 5.0)
	tween.start()
	yield(get_tree().create_timer(7.0), "timeout")
	message.message = MESSAGE_B
	message.update()
	tween.interpolate_property(message, "modulate", Color.transparent, Color.white, 5.0)
	tween.interpolate_property(label_thankyou, "modulate", Color.transparent, Color.white, 5.0, 0, 2, 6.0)
	tween.start()
	yield(get_tree().create_timer(10.0), "timeout")
	tween.interpolate_property(prompt_press_start, "modulate", Color.transparent, Color.white, 3.0)
	can_quit = true
