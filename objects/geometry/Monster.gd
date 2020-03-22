extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D

var facing : float

func update_angle(camera_angle : float) -> void:
	while camera_angle < 360.0:
		camera_angle += 360.0
	var angle : int = floor(fmod(facing + camera_angle, 360.0) / 90.0)
	sprite.frame = angle

func _ready() -> void:
	facing = rand_range(0, 4) * 90.0
