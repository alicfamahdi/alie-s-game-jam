class_name DailyWord
extends Node

var daily_word: String
var daily_letters: PackedStringArray:
	get:
		return daily_word.split("", false)
var available_words: Array[String]

func _init():
	var file_available_words = FileAccess.open(
		"res://assets/data/valid-wordle-words.txt",
		FileAccess.READ
		)
	
	while !file_available_words.eof_reached():
		available_words.append(file_available_words.get_line().to_upper())
	
func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i)
	return s
	
func compare(word):
	var word_from_array = array_to_string(word)
	if (word_from_array) not in available_words:
		return {}
		
	var comp := []
	var results := {
		0: "",
		1: "",
		2: "",
		3: "",
		4: "",
	}

	if typeof(word) == TYPE_ARRAY:
		comp = word
	if typeof(word) == TYPE_STRING:
		comp = (word as String).split("")
	
	for i in range(0, 5):
		if daily_letters[i] == comp[i]:
			results[i] = GameState.TileStatus.CORRECT
		elif daily_letters.find(comp[i]) > -1:
			results[i] = GameState.TileStatus.SEMICORRECT
		else:
			results[i] = GameState.TileStatus.INCORRECT
	return results
