extends Window

@export var task_button : Button
var id = "guide"


func _ready():
	close_requested.connect(task_button.close)

func _process(delta):
	if has_focus():
		task_button.set_notification( false )
		if Globals.focus != id:
			Globals.focus = id
