extends Button

@export var window : Window
@export var icon_normal : Texture2D
@export var icon_notification : Texture2D
@export var sfx : AudioStreamPlayer

var normal_style
var hover_style
var focus_style

static var focused = ""
static var visible_windows = []
static var hidden_windows = []

func _ready():
	normal_style = get_theme_stylebox("normal", "Button")
	hover_style = get_theme_stylebox("hover", "Button")
	focus_style = get_theme_stylebox("focus", "Button")
	
	window.close_requested.connect(close)
	window.on_notification_received.connect(notify)
	
	if window.is_visible():
		visible_windows.append(self)
	else:
		hidden_windows.append(self)
	
	pressed.connect(handle_click)

func _process(delta):
	if !window.is_visible():
		return
		
	if window.has_focus():
		if visible_windows.front() != self:
			#print(window.name, " has gained focus (button focus: ",has_focus(), ")")
			focus()
		
		set_notification( false )
		
	else:
		if visible_windows.front() == self:
			#print(window.name, " has lost focus (button focus: ",has_focus(), ")")
			set_button_style_focused(false)
		release_focus()
			#if visible_windows.front() != null:
				#visible_windows.front().focus()

func handle_click():
	if window.is_visible():
		if visible_windows.front() == self:
			close()
		else:
			focus()
			
	else:
		open()

func focus():
	window.grab_focus()
	set_button_style_focused(true)
	
	if visible_windows.front() != null:
		visible_windows.front().unfocus()
		
	visible_windows.erase(self)
	visible_windows.push_front(self)

func unfocus():
	set_button_style_focused(false)

func close():
	window.hide()
	release_focus()
	set_button_style_focused(false)
	
	visible_windows.erase(self)
	hidden_windows.append(self)
	
	if visible_windows.front() != null:
		visible_windows.front().focus()
	
func open():
	window.show()
	window.grab_focus()
	focus()
	hidden_windows.erase(self)
	
	if visible_windows.front() != null:
		visible_windows.front().unfocus()
		
	visible_windows.push_front(self)

func set_button_style_focused(focus : bool):
	#print(name, " SET BUTTON FOCUS STYLE ", focus)
	if(focus):
			add_theme_stylebox_override("normal", focus_style)
	else:
			remove_theme_stylebox_override("normal")

func notify():
	set_notification(true)

func set_notification(notify : bool):
	if notify:
		add_theme_stylebox_override("normal", hover_style)
		if(icon_notification != null):
			set_button_icon(icon_notification)
		if(sfx != null):
			sfx.play()
	else:
		if(get_theme_stylebox("normal") == hover_style):
			remove_theme_stylebox_override("normal")
		if(icon_normal != null):
			set_button_icon(icon_normal)
