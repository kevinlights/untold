extends "res://objects/geometry/BoardObject.gd"

onready var anim_player = $Base/AnimationPlayer
onready var audio_open = $Audio_Open

var open : bool = false
var fading_audio : bool = false

func tick() -> void:
	if open: return
	# Have all three pedestals been filled?
	var all_filled : bool = true
	for pedestal in get_tree().get_nodes_in_group("pedestal"):
		if not pedestal.has_glyph:
			all_filled = false
	if all_filled:
		anim_player.play("open")
		audio_open.play()
		open = true
		get_tree().set_group("player", "can_move", false)
		yield(get_tree().create_timer(5.0), "timeout")
		fading_audio = true
		get_tree().call_group("ui", "white_out")
		yield(get_tree().create_timer(7.0), "timeout")
		get_tree().change_scene("res://scenes/Ending.tscn")

func _process(delta : float) -> void:
	if fading_audio:
		var bus : int = AudioServer.get_bus_index("SFX")
		var volume : float = AudioServer.get_bus_volume_db(bus)
		volume -= delta * 5.0
		AudioServer.set_bus_volume_db(bus, volume)
