extends Control

const ALPHABET = preload("res://textures/alphabet.png")

const LETTER_SIZE : Vector2 = Vector2(8, 8)
const MAX_LINE_SIZE : int = 70

const MESSAGE : Array = [
	[13,10,0,4,5,1,18,0,6,18,9,5,14,4],
	[2,10,0,20,8,5,0,20,9,13,5,0,10,15,21,0,18,5,1,4,0,20,8,9,19,0,13,5,19,19,1,7,5,0,17,5,0,17,9,12,12,0,8,1,22,5,0,3,15,13,16,12,5,20,5,4,0,15,21,18,0,18,5,20,18,5,1,20],
	[1,14,4,0,20,8,5,19,5,0,8,1,12,12,15,17,5,4,0,3,8,1,13,2,5,18,19,0,17,9,12,12,0,9,14,0,1,12,12,0,12,9,11,5,12,9,8,15,15,4,0,2,5,0,15,22,5,18,18,21,14],
	[9,0,11,14,15,17,0,20,8,1,20,0,9,20,0,9,19,0,10,15,21,18,0,17,1,10,0,20,15,0,6,18,5,20,0,2,21,20,0,4,15,0,14,15,20,0,17,15,18,18,10,0,6,15,18,0,21,19],
	[2,10,0,10,15,21,18,0,5,6,6,15,18,20,19,0,15,6,0,12,15,14,7,0,1,7,15,0,17,5,0,17,5,18,5,0,1,2,12,5,0,20,15,0,19,5,3,21,18,5,0,15,21,18,19,5,12,22,5,19],
	[1,7,1,9,14,19,20,0,20,8,5,0,19,3,15,21,18,7,5,0,20,8,1,20,0,14,15,17,0,5,14,7,21,12,6,19,0,20,8,9,19,0,17,15,18,12,4],
	[9,20,0,19,1,4,4,5,14,19,0,13,5,0,20,8,1,20,0,15,21,18,0,18,5,21,14,9,15,14,0,13,21,19,20,0,15,14,3,5,0,13,15,18,5,0,2,5,0,4,5,12,1,10,5,4],
	[2,21,20,0,19,8,15,21,12,4,0,17,5,0,14,15,20,0,5,13,5,18,7,5,0,6,18,15,13,0,20,8,9,19,0,4,1,18,11,0,14,9,7,8,20],
	[11,14,15,17,0,20,8,1,20,0,17,5,0,6,1,4,5,4,0,16,5,1,3,5,6,21,12,12,10,0,3,15,14,20,5,14,20,0,9,14,0,20,8,5,0,11,14,15,17,12,5,4,7,5],
	[20,8,1,20,0,20,8,5,0,5,3,8,15,5,19,0,15,6,0,15,21,18,0,20,18,5,1,4,0,1,14,4,0,22,15,9,3,5,0,19,20,9,12,12,0,18,5,19,15,14,1,20,5],
	[9,14,0,8,21,13,2,12,5,0,7,18,1,14,4,17,5,12,12,0,14,15,17,0,19,15,0,6,1,18,0,1,17,1,10]
]

func _draw() -> void:
	var offset : Vector2 = Vector2.ZERO
	for line in MESSAGE:
		offset.x = (MAX_LINE_SIZE - line.size()) * (LETTER_SIZE.x / 2.0)
		for letter in line:
			var pos : Vector2 = Vector2(letter % 6, letter / 6)
			draw_texture_rect_region(ALPHABET, Rect2(offset, LETTER_SIZE), Rect2(pos * LETTER_SIZE, LETTER_SIZE))
			offset.x += 8
		offset.y += 8
