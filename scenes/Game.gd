extends Spatial

onready var level = $Level
onready var ui = $UI

var levels : Array = [
	"res://maps/test1.png",
	"res://maps/test2.png",
	"res://maps/test3.png"
]

func _ready():
	GameSession.enter_level()
	LevelBuilder.load_map(levels[GameSession.level], level)
	ui.init_map(levels[GameSession.level])
	ui.update_ui()
