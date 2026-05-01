extends MarginContainer


func _ready():
	self.modulate = Color(1, 1, 1, 0)
	
func _process(delta: float) -> void:
	self.modulate = Color(1, 1, 1, 1)
	
	var tween_reference = create_tween()
	tween_reference.tween_interval(2)
	tween_reference.tween_property(self, "modulate", Color(1,1,1,0), 0.5)
