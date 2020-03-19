extends Spatial

onready var geometry = $Level

var levels : Array = [
	"res://maps/test1.png",
	"res://maps/test2.png"
]

func _ready():
	LevelBuilder.load_map(levels[GameSession.level], geometry)
