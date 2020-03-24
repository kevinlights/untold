extends CanvasLayer

onready var keys_value = $StatusBar/Keys/Value
onready var bombs_value = $StatusBar/Bombs/Value
onready var treasure_value = $StatusBar/Treasure/Value

onready var status_keys = $StatusBar/Keys
onready var status_bombs = $StatusBar/Bombs
onready var status_secrets = $StatusBar/Secrets

onready var key_interact = $Keys/Interact
onready var key_bomb = $Keys/Bomb
onready var key_map = $Keys/Map

onready var map = $Map
onready var blackout = $Blackout
onready var shader = $Shader

onready var tween = $Tween

func update_ui() -> void:
	keys_value.text = str(GameSession.keys)
	bombs_value.text = str(GameSession.bombs)
	treasure_value.text = str(GameSession.treasure_collected)
	status_keys.visible = GameSession.keys > 0
	status_bombs.visible = GameSession.bombs > 0
	if GameSession.level < 3:
		status_secrets.visible = GameSession.glyphs_collected[GameSession.level]
	else:
		status_secrets.visible = false
	key_interact.visible = get_parent().level.get_player().can_interact()
	key_bomb.visible = GameSession.bombs > 0
	key_map.visible = GameSession.got_map
	# Update map
	map.player_position = get_parent().level.get_player().board_position # the jankiest hack. ew.
	map.update()

func set_map(image : Image) -> void:
	map.set_map(image)

func set_palette(palette) -> void:
	shader.texture = palette

func fade_in() -> void:
	tween.interpolate_property(blackout, "color", Color.black, Color(0.0, 0.0, 0.0, 0.0), 2.0)
	tween.start()

func fade_out() -> void:
	tween.interpolate_property(blackout, "color", Color(0.0, 0.0, 0.0, 0.0), Color.black, 2.0)
	tween.start()

func white_out() -> void:
	tween.interpolate_property(blackout, "color", Color(1.0, 1.0, 1.0, 0.0), Color.white, 5.0)
	tween.start()
