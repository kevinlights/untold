extends "res://objects/geometry/BoardObject.gd"

onready var anim_player = $Base/AnimationPlayer
onready var audio_open = $Audio_Open
onready var audio_music = $Audio_Music # Yes, the statue controls the music! Go figure.
onready var tween = $Tween

var open : bool = false
var playing_music : bool = true
var fading_audio : bool = false
var doing_bad_ending : bool = false

func tick() -> void:
	if open: return
	# Does the player have all three glyphs?
	var got_all_glyphs : bool = true
	# Have all three pedestals been filled?
	var all_filled : bool = true
	# Has the player filled all of the pedestals they can?
	var all_spent : bool = true
	for pedestal in get_tree().get_nodes_in_group("pedestal"):
		if not GameSession.glyphs_collected[pedestal.which_glyph]:
			got_all_glyphs = false
		if not pedestal.has_glyph:
			all_filled = false
			if not pedestal.has_glyph and GameSession.glyphs_collected[pedestal.which_glyph]:
				all_spent = false
	# If the player has just stepped through the threshold, fade out the music
	if level.get_player().board_position.x >= 9 and playing_music and (got_all_glyphs or all_spent):
		tween.interpolate_property(audio_music, "volume_db", 0, -80, 10)
		tween.start()
		playing_music = false
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
	else:
		if all_spent and playing_music == false and doing_bad_ending == false:
			doing_bad_ending = true
			tween.interpolate_property(audio_music, "volume_db", 0, -80, 10)
			tween.start()
			playing_music = false
			yield(get_tree().create_timer(8.0), "timeout")
			get_tree().call_group("ui", "fade_out")
			yield(get_tree().create_timer(2.0), "timeout")
			get_tree().change_scene("res://scenes/BadEnding.tscn")

func _process(delta : float) -> void:
	if fading_audio:
		var bus : int = AudioServer.get_bus_index("SFX")
		var volume : float = AudioServer.get_bus_volume_db(bus)
		volume -= delta * 5.0
		AudioServer.set_bus_volume_db(bus, volume)

func _ready() -> void:
	audio_music.play()
