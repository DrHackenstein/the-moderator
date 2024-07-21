extends Button

@export var window : Node
var icon_normal : Texture2D
var icon_notification : Texture2D

var window_visible = true

func _ready():
	self.pressed.connect(self.handle_click)
	
	
func handle_click():
	if window_visible:
		if Globals.focus == window.id:
			window_visible = false
			window.hide()
		else:
			window.grab_focus()
	else:
		window_visible = true
		window.show()

func set_notification(notify : bool):
	if notify:
		set_button_icon(icon_notification)
	else:
		set_button_icon(icon_normal)
