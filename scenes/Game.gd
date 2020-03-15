extends Spatial

onready var geometry = $Level

func _ready():
	LevelBuilder.load_map("res://maps/test1.png", geometry)
