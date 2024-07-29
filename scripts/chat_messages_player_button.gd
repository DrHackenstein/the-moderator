extends MarginContainer

@export var button : Button
@export var message : RichTextLabel
 
var content : Content

func _ready():
	button.button_down.connect(select)

func load(new_content : Content, debug : bool = false):
	content = new_content
	if debug:
		message.text = content.id + ": " + content.text
	else:
		message.text = content.text

func select():
	
	print("Select  Answer  ", content.id, ": ", content.text)
	
	# Add self as response message
	var chat_window = get_tree().current_scene.get_node("%Chat_Window")
	chat_window.add_response_text(content)
	
	# Delete buttons
	chat_window.remove_response_buttons()
	
	# Load button follow ids
	if content.follow.size() > 0:
		print("Loading Answer  ", content.id, " Followers:")
		for id in content.follow:
			var content_manager = get_tree().current_scene.get_node("%Content_Manager")
			content_manager.load_content(id, true)
