extends VBoxContainer

func update_key(letter: String, status: GameState.TileStatus):
	for row in get_children():
		for key in row.get_children():
			if key is Tile and key.get_node("Label").text == letter:
				match status:
					GameState.TileStatus.CORRECT:
						key.theme_type_variation = "TileCorrect"
					GameState.TileStatus.SEMICORRECT:
						if key.theme_type_variation != "TileCorrect":
							key.theme_type_variation = "TileSemiCorrect"
					GameState.TileStatus.INCORRECT:
						if key.theme_type_variation == "":
							key.theme_type_variation = "TileIncorrect"
							
func reset_keys():
	for row in get_children():
		for key in row.get_children():
			if key is Tile:
				key.theme_type_variation = "Tile"
