extends Button

@export var window : Node
@export var icon_normal : Texture2D
@export var icon_notification : Texture2D
@export var sfx : AudioStreamPlayer

@export var window_visible = true

func _ready():
	self.pressed.connect(self.handle_click)
	
	
func handle_click():
	if window_visible:
		if Globals.focus == window.id:
			close()
		else:
			window.grab_focus()
	else:
		window_visible = true
		window.show()
		window.grab_focus()

func close():
	Globals.focus = "None"
	window_visible = false
	window.hide()

func set_notification(notify : bool):
	if notify:
		if(icon_notification != null):
			set_button_icon(icon_notification)
		if(sfx != null):
			sfx.play()
	else:
		if(icon_normal != null):
			set_button_icon(icon_normal)
