extends MarginContainer

@export var button : Button
@export var message : RichTextLabel
 
var content : Content

func _ready():
	button.button_down.connect(select)

func load(new_content : Content):
	content = new_content
	message.text = content.text

func select():
	if content.follow.is_empty():
		return
	
	# Add self as response message
	var chat_window = get_tree().current_scene.get_node("%Chat_Window")
	chat_window.add_response_text(content)
	
	# Delete buttons
	chat_window.remove_response_buttons()
	
	# Load button follow ids
	for id in content.follow:
		var content_manager = get_tree().current_scene.get_node("%Content_Manager")
		content_manager.load_content(id, true)
