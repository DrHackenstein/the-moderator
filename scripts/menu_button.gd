extends Button

@export var menu : Node

func _ready():
	button_down.connect(open_menu)

func open_menu():
	if(menu.is_visible()):
		menu.hide()
	else:
		menu.show()
		
	release_focus()
