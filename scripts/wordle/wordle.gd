extends MarginContainer

@export var daily_word: String
@export var tile_rows: Array[TileRow]
@export var timer_seconds: float
var target_word: DailyWord
var current_guess := []
var guess_index: int = 0
var current_tile: Tile:
	get:
		var row = tile_rows[guess_index]
		return row.tiles[min(current_guess.size(), 4)]
var previous_tile: Tile:
	get:
		var row = tile_rows[guess_index]
		return row.tiles[max(current_guess.size() - 1, 0)]
var success: bool
@onready var invalid_word = $InvalidWord
@onready var timer = $Timer
var time_left: float
var iw_tween_reference = null

signal scene_completed  
signal scene_failed

func _ready() -> void:
	target_word = DailyWord.new()
	target_word.daily_word = daily_word
	add_child(target_word)
	invalid_word.modulate = Color(1, 1, 1, 0)
	
func activate():
	start_countdown(timer_seconds)

func _process(delta: float) -> void:
	update_display()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_modifiers_mask() == 0:
			if not event.echo:
				if event.keycode >= KEY_A and event.keycode <= KEY_Z:
					handle_guess_input(event.as_text())
				elif event.keycode == KEY_ENTER:
					submit_guess()
			if event.keycode == KEY_BACKSPACE:
				handle_erase_input(event.as_text())

func show_invalid_word():
	if iw_tween_reference:
		iw_tween_reference.kill()
	
	invalid_word.modulate = Color(1, 1, 1, 1)
	
	iw_tween_reference = create_tween()
	iw_tween_reference.tween_interval(2)
	iw_tween_reference.tween_property(invalid_word, "modulate", Color(1,1,1,0), 0.5)
	
func handle_guess_input(key: String):
	if !success:
		if current_guess.size() < 5:
			current_tile.label.text = key
			current_guess.append(key)

func submit_guess():
	if !success:
		if current_guess.size() == 5:
			var results = (target_word.compare(current_guess))
			if results == {}:
				show_invalid_word()
				return
			var current_tiles := tile_rows[guess_index].tiles
			guess_index += 1
			if guess_index >= tile_rows.size():
				timer.stop()
				scene_failed.emit()
				return
			current_guess = []
			if (results == { 0: 0, 1: 0, 2: 0, 3: 0, 4: 0 }):
				success = true
				timer.stop()
				scene_completed.emit()
				return
			
			for i in range(0, 5):
				current_tiles[i].submit(results[i])

func handle_erase_input(key: String):
	if !success:
		if current_guess.size() > 0:
			previous_tile.label.text = ""
			current_guess.pop_back()
			
func start_countdown(seconds: float):
	timer.timeout.connect(_on_timer_timeout)
	time_left = seconds
	timer.wait_time = 1.0  # tick every second
	timer.start()

func _on_timer_timeout():
	time_left -= 1
	update_display()
	if time_left <= 0:
		timer.stop()
		on_time_up()

func update_display():
	#$HBoxContainer/VBoxContainer/Label.text = str(time_left)  # or format it nicely:
	$HBoxContainer/VBoxContainer/Label.text = "%02d:%02d" % [time_left / 60, fmod(time_left, 60)]

func on_time_up():
	scene_failed.emit()
