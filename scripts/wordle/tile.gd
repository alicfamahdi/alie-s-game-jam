class_name Tile
extends Panel

@export var label: Label
var theme_variants := [&"TileCorrect", &"TileSemiCorrect", &"TileIncorrect"]

func submit(tile_status: GameState.TileStatus):
	theme_type_variation = theme_variants[tile_status]

func reset():
	# restore original style/color
	theme_type_variation = "Tile"
	label.text = ""
