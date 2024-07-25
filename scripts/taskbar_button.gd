extends Button

@export var window : Node
@export var icon_normal : Texture2D
@export var icon_notification : Texture2D
@export var sfx : AudioStreamPlayer

var normal_style
var hover_style
var focus_style

static var focused = ""
var in_focus = false

func _ready():
	normal_style = get_theme_stylebox("normal", "Button")
	hover_style = get_theme_stylebox("hover", "Button")
	focus_style = get_theme_stylebox("focus", "Button")
	
	window.close_requested.connect(close)
	window.on_notification_received.connect(notify)
	
	pressed.connect(handle_click)

func _process(delta):
	if window.has_focus():
		if focused != window.name:
			focused = window.name
		
		if in_focus == false:
			set_focus(true)
		
		set_notification( false )
		in_focus = true
		
	else:
		if in_focus == true:
			set_focus(false)
			
		in_focus = false

func handle_click():
	if window.is_visible():
		if focused == window.name:
			close()
		else:
			focus()
			
	else:
		open()

func focus():
	window.grab_focus()
	set_focus(true)

func close():
	window.hide()
	set_focus(false)
	release_focus()
	
func open():
	window.show()
	focus()

func set_focus(focus : bool):
	if(focus):
			add_theme_stylebox_override("normal", focus_style)
	else:
			remove_theme_stylebox_override("normal")

func notify():
	set_notification(true)

func set_notification(notify : bool):
	if notify:
		if(icon_notification != null):
			set_button_icon(icon_notification)
			add_theme_stylebox_override("normal", hover_style)
		if(sfx != null):
			sfx.play()
	else:
		if(icon_normal != null):
			remove_theme_stylebox_override("normal")
			set_button_icon(icon_normal)
