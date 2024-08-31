extends RichTextLabel

@export var timer : Timer

func _ready():
	timer.timeout.connect(update_timer)

func update_timer():
	match text:
		"...":
			text = ".."
		"..":
			text = "."
		".":
			text = "..."
