extends MarginContainer

@export var message : Button
 
var current : Content

func _ready():
	message.button_down.connect(select)

func load(content : Content):
	current = content
	message.text = content.text

func select():
	if current.follow.is_empty():
		return
	
	# Add self as response message
	var chat_window = get_tree().current_scene.get_node("%Chat_Window")
	chat_window.add_response(current)
	
	# Delete buttons
	chat_window.remove_response_buttons()
	
	# Load button follow ids
	for id in current.follow:
		var content_manager = get_tree().current_scene.get_node("%Content_Manager")
		content_manager.load_content(id, true)
