extends MarginContainer

@export var message : RichTextLabel
var content

func load(new_content : Content, debug : bool = false):
	content = new_content
	
	if debug:
		message.text = content.id + ": " + content.text
	else:
		message.text = content.text
