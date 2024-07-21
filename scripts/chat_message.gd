extends MarginContainer

@export var message : RichTextLabel
var content

func load(new_content : Content):
	content = new_content
	message.text = content.text
