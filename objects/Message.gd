extends Control

const ALPHABET = preload("res://textures/alphabet.png")

const LETTER_SIZE : Vector2 = Vector2(8, 8)
const MAX_LINE_SIZE : int = 70

var message : Array

func _draw() -> void:
	var offset : Vector2 = Vector2(0.0, -message.size() * LETTER_SIZE.y * 0.5)
	for line in message:
		var line_width : float = line.size() * LETTER_SIZE.x
		offset.x = -line_width / 2.0
		for letter in line:
			var pos : Vector2 = Vector2(letter % 6, letter / 6)
			draw_texture_rect_region(ALPHABET, Rect2(offset, LETTER_SIZE), Rect2(pos * LETTER_SIZE, LETTER_SIZE))
			offset.x += 8
		offset.y += 8
