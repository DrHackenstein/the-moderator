extends Button

@export var icon_normal : Texture2D
@export var icon_notification : Texture2D
@export var timer : Timer

var normal_style
var hover_style
var focus_style

func _ready():
	normal_style = get_theme_stylebox("normal", "Button")
	hover_style = get_theme_stylebox("hover", "Button")
	focus_style = get_theme_stylebox("focus", "Button")
	
	timer.timeout.connect(blink_button)

func focus():
	set_button_style_focused(true)

func unfocus():
	set_button_style_focused(false)

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
		start_blinking()
		set_button_icon(icon_notification)
	else:
		stop_blinking()
		set_button_icon(icon_normal)

func start_blinking():
	blink_button()
	timer.start()
	
func stop_blinking():
	timer.stop()
	blink = true
	blink_button()

var blink = false
func blink_button():
	blink = !blink
	if(blink):
			add_theme_stylebox_override("normal", hover_style)
	elif get_theme_stylebox("normal") == hover_style:
			remove_theme_stylebox_override("normal")
