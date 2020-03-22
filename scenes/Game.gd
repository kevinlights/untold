extends Spatial

onready var level = $Level
onready var ui = $UI
onready var ambience = $Ambience
onready var tween = $Tween

const AMBIENCE_TRACKS : Array = [
	preload("res://audio/ambience/level1.ogg"),
	preload("res://audio/ambience/level2.ogg"),
	preload("res://audio/ambience/level3.ogg")
]

const LEVELS : Array = [
	"res://maps/level1.png",
	"res://maps/level2.png",
	"res://maps/level3.png",
	"res://maps/level4.png"
]

func fade_out_ambience() -> void:
	tween.interpolate_property(ambience, "volume_db", ambience.volume_db, -80, 3.0)
	tween.start()

func _ready():
	GameSession.enter_level()
	LevelBuilder.load_map(LEVELS[GameSession.level], level)
	ui.init_map(LEVELS[GameSession.level])
	if GameSession.level < 3:
		ambience.stream = AMBIENCE_TRACKS[GameSession.level]
		tween.interpolate_property(ambience, "volume_db", -30.0, -10.0, 3.0)
		tween.start()
		yield(get_tree().create_timer(0.1), "timeout")
		ambience.play()
		yield(get_tree().create_timer(1.0), "timeout")
	ui.update_ui()
	ui.fade_in()
	level.start_level()
	
