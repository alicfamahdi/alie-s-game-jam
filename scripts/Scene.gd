extends Control

@export var load_image: String
@export var load_dialogue: String
@export var unskippable: bool

signal scene_completed
signal scene_failed

func activate():
	if load_image:
		$TextureRect.texture = load("res://assets/visuals/" + load_image + ".png")
	if load_dialogue:
		DialogueManager.show_dialogue_balloon_scene(
			preload("res://addons/dialogue_manager/example_balloon/example_balloon.tscn"),
			load("res://dialogues/" + load_dialogue + ".dialogue"),
			"start")

func go_to_menu():
	get_tree().change_scene_to_file("res://scenes/StartMenu.tscn")
