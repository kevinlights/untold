extends "res://objects/geometry/BoardObject.gd"

onready var sprite = $Sprite3D
onready var audio_get = $Audio_Get
onready var anim_player : AnimationPlayer = $AnimationPlayer

onready var collected : bool = false

func is_solid() -> bool:
	return false

func is_interactive() -> bool:
	return false

func tick() -> void:
	if collected: return
	if level.get_player().board_position == board_position:
		audio_get.play()
		collected = true
		hide()
		GameSession.got_map = true
		var ui = get_tree().get_nodes_in_group("ui")[0]
		ui.map.visible = !ui.map.visible

func _ready() -> void:
	anim_player.play("float")
