extends Popup

@export var credits_button : Button
@export var quit_button : Button

func _ready():
	quit_button.button_down.connect(quit_game)
	credits_button.button_down.connect(open_credits)
	%Credits.close_requested.connect(close_credits)

func open_credits():
	if %Credits.is_visible():
		%Credits.grab_focus()
	else:
		%Credits.show()
	
	hide()

func close_credits():
	%Credits.hide()

func quit_game():
	get_tree().quit()
