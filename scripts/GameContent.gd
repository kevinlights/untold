extends Node

const ORIGINAL_MAP_PATH : String = "res://maps"
const ORIGINAL_PALETTE_PATH : String = "res://textures/palettes"
const CUSTOM_MAP_PATH : String = "user://maps"
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

const ORIGINAL_MAPS : Array = [
	preload("res://maps/level1.png"),
	preload("res://maps/level2.png"),
	preload("res://maps/level3.png"),
	preload("res://maps/level4.png")
]

const ORIGINAL_PALETTES : Array = [
	preload("res://textures/palettes/slso8.png"),
	preload("res://textures/palettes/title.png"),
	preload("res://textures/palettes/hot.png"),
	preload("res://textures/palettes/cold_blue.png")
]

var maps : Array
var palettes : Array

func load_map(which : int) -> Image:
	var file : File = File.new()
	var path : String = CUSTOM_MAP_PATH + "/" + MAP_FILES[which]
	if file.file_exists(path):
		var image : ImageTexture = ImageTexture.new()
		image.load(path)
		var map : Image = image.get_data()
		map.lock()
		return map
	else:
		var map : Image = ORIGINAL_MAPS[which].get_data()
		map.lock()
		return map

func load_palette(which : int) -> Texture:
	var file : File = File.new()
	var path : String = CUSTOM_PALETTE_PATH + "/" + PALETTE_FILES[which]
	if file.file_exists(path):
		var image : Texture = ImageTexture.new()
		image.load(path)
		image.flags = image.FLAG_FILTER
		return image
	else:
		return ORIGINAL_PALETTES[which]

func get_map(which : int) -> Image:
	return maps[which]

func get_palette(which : int) -> Image:
	return palettes[which]

func load_content() -> void:
	maps = [null, null, null, null]
	palettes = [null, null, null, null]
	for i in range(0, MAP_FILES.size()):
		maps[i] = load_map(i)
	for i in range(0, PALETTE_FILES.size()):
		palettes[i] = load_palette(i)

func _ready() -> void:
	load_content()
