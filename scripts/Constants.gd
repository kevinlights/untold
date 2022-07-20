extends Node

const COLOUR_FLOOR : Color = Color("000000")
const COLOUR_FLOOR_HIGH_CEILING : Color = Color("45283c")
const COLOUR_WALL : Color = Color("595652")
const COLOUR_WATER : Color = Color("306082")
const COLOUR_WATER_TUNNEL : Color = Color("5b6ee1")
const COLOUR_PLAYER_START : Color = Color("4b692f")
const COLOUR_TORCH : Color = Color("fbf236")
const COLOUR_TREASURE : Color = Color("df7126")
const COLOUR_MONSTER : Color = Color("ac3232")
const COLOUR_DOOR : Color = Color("8f563b")
const COLOUR_LOCKED_DOOR : Color = Color("663931")
const COLOUR_KEY : Color = Color("eec39a")
const COLOUR_LEVEL_EXIT : Color = Color("37946e")
const COLOUR_WEAK_WALL : Color = Color("696a6a")
const COLOUR_CHEST_WITH_BOMBS : Color = Color("323c39")
const COLOUR_GLYPH : Color = Color("9badb7")
const COLOUR_MAP : Color = Color("d9a066")
const COLOUR_PEDESTAL : Color = Color("cbdbfc")
const COLOUR_STATUE : Color = Color("ffffff")
const COLOUR_INVISIBLE_WALL : Color = Color("76428a")
const COLOUR_INVISIBLE_WALL_HIGH_CEILING : Color = Color("d77bba")

const STATIC_BLOCKERS : Array = [
	COLOUR_WALL, COLOUR_TORCH, COLOUR_PEDESTAL, COLOUR_STATUE,
	COLOUR_TREASURE, COLOUR_CHEST_WITH_BOMBS,
	COLOUR_INVISIBLE_WALL, COLOUR_INVISIBLE_WALL_HIGH_CEILING
]

const WATER_CELLS : Array = [
	COLOUR_WATER, COLOUR_WATER_TUNNEL
]
