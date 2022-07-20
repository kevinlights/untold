extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D

var facing : float

func update_angle(camera_angle : float) -> void:
	while camera_angle < PI * 2.0:
		camera_angle += PI * 2.0
	var angle : int = floor(fmod(facing + camera_angle, PI * 2.0) / (PI / 2.0))
	sprite.frame = angle

func _ready() -> void:
	facing = rand_range(0, 4) * (PI / 2.0)
