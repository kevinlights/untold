extends Spatial

onready var level = $Level
onready var camera = $Camera

var map : Image

func is_space_free(position : Vector2) -> bool:
	for object in get_tree().get_nodes_in_group("board_object"):
		if object.board_position == position and object.is_solid():
			return false
	return true

func reset_camera() -> void:
	camera.translation.x = 8
	camera.rotation_degrees.z = -45

func _process(delta : float) -> void:
	camera.translation.x += delta * 0.5
	camera.rotation_degrees.z += delta * 3.0

func _ready():
	rand_seed(15)
	var map : Image = load("res://maps/demo.png").get_data()
	map.lock()
	LevelBuilder.load_map(map, self)
	# janky fix, no regrets
	for monster in get_tree().get_nodes_in_group("monster"):
		monster.sprite.billboard = 0
		monster.sprite.rotation_degrees.y = 90
		monster.sprite.frame = rand_range(0, 3)
	for torch in get_tree().get_nodes_in_group("torch"):
		torch.sprite.billboard = 0
		torch.sprite.rotation_degrees.y = 90
