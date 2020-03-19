extends Control

onready var video = $VideoPlayer
onready var music = $Audio_Music
onready var tween = $Tween

func _on_VideoPlayer_finished():
	video.play()

func _ready() -> void:
	yield(get_tree().create_timer(4.0), "timeout")
	video.play()
	music.play()
	tween.interpolate_property(video, "modulate", Color.black, Color.gray, 0.5)
	tween.start()
