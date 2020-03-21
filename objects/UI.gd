extends CanvasLayer

onready var health_value = $StatusBar/Health/Value
onready var keys_value = $StatusBar/Keys/Value
onready var bombs_value = $StatusBar/Bombs/Value
onready var treasure_value = $StatusBar/Treasure/Value

onready var status_keys = $StatusBar/Keys
onready var status_bombs = $StatusBar/Bombs

onready var key_bomb = $Keys/Bomb
onready var key_map = $Keys/Map

onready var map = $Map

func update_ui() -> void:
	health_value.text = str(GameSession.health)
	keys_value.text = str(GameSession.keys)
	bombs_value.text = str(GameSession.bombs)
	treasure_value.text = str(GameSession.treasure_collected)
	status_keys.visible = GameSession.keys > 0
	status_bombs.visible = GameSession.bombs > 0
	key_bomb.visible = GameSession.bombs > 0
	key_map.visible = GameSession.got_map
	# Update map
	map.player_position = get_parent().level.get_player().board_position # the jankiest hack. ew.
	map.update()

func init_map(path : String) -> void:
	map.load_map(path)
