extends Button

func _on_pressed():
	if "Button":
		ChosenCharacter.chosen_character = ChosenCharacter.Character.TWYLA
		get_parent().get_parent().get_parent().get_parent().get_parent().scene_completed.emit()
