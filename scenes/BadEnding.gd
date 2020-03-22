extends Control

onready var background = $Background
onready var blackout = $Blackout
onready var label_ending = $Label_Ending
onready var tween = $Tween

func _ready() -> void:
	yield(get_tree().create_timer(2.0), "timeout")
	var bus : int = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus, 0)
	tween.interpolate_property(label_ending, "modulate", Color.transparent, Color.white, 1.0)
	tween.start()
	yield(get_tree().create_timer(10.0), "timeout")
	tween.interpolate_property(label_ending, "modulate", Color.white, Color.transparent, 5.0)
	tween.start()
	yield(get_tree().create_timer(7.0), "timeout")
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
	
