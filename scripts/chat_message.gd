extends MarginContainer

@export var message : RichTextLabel

func load(content : Content):
	message.text = content.text
