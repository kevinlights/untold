extends Node

const ORIGINAL_MAP_PATH : String = "res://maps"
const CUSTOM_MAP_PATH : String = "user://maps"

const ORIGINAL_PALETTE_PATH : String = "res://textures/palettes"
const CUSTOM_PALETTE_PATH : String = "user://palettes"

const MAP_FILES : Array = [
	"level1.png",
	"level2.png",
	"level3.png",
	"level4.png"
]

const PALETTE_FILES : Array = [
	"slso8.png",
	"title.png",
	"hot.png",
	"cold_blue.png"
]

var maps : Array
var palettes : Array

func load_map(path : String) -> Image:
	var image : ImageTexture = ImageTexture.new()
	image.load(path)
	var map : Image = image.get_data()
	map.lock()
	return map

func load_palette(path : String) -> ImageTexture:
	var image : ImageTexture = ImageTexture.new()
	image.load(path)
	image.flags = image.FLAG_FILTER
	return image

func get_map(which : int) -> Image:
	return maps[which]

func get_palette(which : int) -> Image:
	return palettes[which]

func load_content() -> void:
	maps = [null, null, null, null]
	for i in range(0, MAP_FILES.size()):
		maps[i] = load_map(CUSTOM_MAP_PATH + "/" + MAP_FILES[i])
	palettes = [null, null, null, null]
	for i in range(0, PALETTE_FILES.size()):
		palettes[i] = load_palette(CUSTOM_PALETTE_PATH + "/" + PALETTE_FILES[i])

# During first time installation, content is loaded into user directory for easier modification
func extract_content() -> void:
	var d : Directory = Directory.new()
	if not d.dir_exists(CUSTOM_MAP_PATH):
		d.make_dir(CUSTOM_MAP_PATH)
		for map in MAP_FILES:
			d.copy(ORIGINAL_MAP_PATH + "/" + map, CUSTOM_MAP_PATH + "/" + map)
	if not d.dir_exists(CUSTOM_PALETTE_PATH):
		d.make_dir(CUSTOM_PALETTE_PATH)
		for palette in PALETTE_FILES:
			d.copy(ORIGINAL_PALETTE_PATH + "/" + palette, CUSTOM_PALETTE_PATH + "/" + palette)

func _ready() -> void:
	extract_content()
	load_content()
