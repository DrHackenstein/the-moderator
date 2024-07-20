extends Button

@export var window : Node

var window_visible = true

func _ready():
	self.pressed.connect(self.handle_click)
	
	
func handle_click():
	if window_visible:
		if window.has_focus():
			window_visible = false
			window.hide()
		else:
			window.grab_focus()
	else:
		window_visible = true
		window.show()
