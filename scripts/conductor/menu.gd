extends Node2D

func _on_Start_Button_button_down():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 
								linear_to_db($HSlider.value))
	if get_tree().change_scene_to_file("res://scenes/conductor/Game.tscn") != OK:
		print ("Error changing scene to Game")


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),
								linear_to_db(value))


func _on_TextureButton_pressed():
	$TextureButton/AudioStreamPlayer.play()


func _on_link_button_button_down() -> void:
	pass # Replace with function body.
