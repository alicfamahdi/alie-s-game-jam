extends Control

@export var scenes: Array[NodePath]
var current_index = 0
var dialogue_active = false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	for i in scenes.size():
		get_node(scenes[i]).visible = false
	activate_scene(get_node(scenes[0]))

func _unhandled_input(event):
	var current_scene = get_node(scenes[current_index])
	var active = get_active_scene(current_scene)
	if Input.is_action_pressed("ui_accept") and not current_scene.unskippable:			
		next_scene()

func get_active_scene(node: Node) -> Node:
	if node.name.begins_with("branch"):
		if ChosenCharacter.chosen_character == ChosenCharacter.Character.TWYLA:
			return node.get_node("Twyla")
		else:
			return node.get_node("Celestine")
	return node

func _on_dialogue_started(_resource):
	dialogue_active = true

func _on_dialogue_ended(_resource):
	dialogue_active = false
	next_scene()

func next_scene():
	get_node(scenes[current_index]).visible = false
	current_index += 1
	if current_index < scenes.size():
		var next = get_node(scenes[current_index])
		activate_scene(next)

func activate_scene(node: Node):
	# check if it's a branch
	if node.name.begins_with("Branch"):
		var character_scene: Node
		if ChosenCharacter.chosen_character == ChosenCharacter.Character.TWYLA:
			character_scene = node.get_node("Twyla")
		else:
			character_scene = node.get_node("Celestine")
		node.visible = true
		character_scene.visible = true
		character_scene.activate()
		if character_scene.has_signal("scene_completed"):
			character_scene.scene_completed.connect(_on_scene_completed)
		if character_scene.has_signal("scene_failed"):
			character_scene.scene_failed.connect(_on_scene_failed, CONNECT_ONE_SHOT)	
	else:
		node.visible = true
		node.activate()
		if node.has_signal("scene_completed"):
			node.scene_completed.connect(_on_scene_completed)
		if node.has_signal("scene_failed"):
			node.scene_failed.connect(_on_scene_failed, CONNECT_ONE_SHOT)

func _on_scene_failed():
	var steps_back = 1  # however many scenes back you want
	get_node(scenes[current_index]).visible = false
	current_index = max(0, current_index - steps_back)
	activate_scene(get_node(scenes[current_index]))

func _on_scene_completed():
	next_scene()
