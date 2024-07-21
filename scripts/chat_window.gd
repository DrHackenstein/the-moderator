extends Window

@export var doro_button : Button
@export var basti_button : Button

@export var doro_chat : Control
@export var doro_chat_container : VBoxContainer
@export var basti_chat : Control
@export var basti_container : VBoxContainer

var message_player
var message_other
var message_response

var scrollbar
var scrollcontainer
var responses = []
var waiting_list = [0, 0]

func _ready():
	load_message_nodes()
	doro_button.button_down.connect(toggle_doro)
	basti_button.button_down.connect(toggle_basti)

func load_message_nodes():
	if message_other == null:
		message_other = load("res://scenes/chat_messages_other.tscn")
		
	if message_player == null:
		message_player = load("res://scenes/chat_messages_player.tscn")
		
	if message_response == null:
		message_response = load("res://scenes/chat_messages_player_button.tscn")

func load(content : Content):
	print("Loading Chat: " + content.id + " " + content.text)
	
	load_message_nodes()
	
	var message
	var wait_time
	
	match content.uid:
		"Doro":
			wait_time = randf_range(1.0, 3.0)
			waiting_list[0] += wait_time
			await get_tree().create_timer(waiting_list[0]).timeout
			add(content, message_other.instantiate(), doro_chat_container)
			waiting_list[0] -= wait_time
		"Basti":
			wait_time = randf_range(1.0, 3.0)
			waiting_list[1] += wait_time
			await get_tree().create_timer(waiting_list[1]).timeout
			add(content, message_other.instantiate(), basti_container)
			waiting_list[1] -= wait_time
		"Player":
			match content.wid:
				"Doro":
					await get_tree().create_timer(waiting_list[0]+0.4).timeout
					add(content, message_response.instantiate(), doro_chat_container, true)
			
				"Basti":
					await get_tree().create_timer(waiting_list[1]+0.4).timeout
					add(content, message_response.instantiate(), basti_container, true)
			

func add(content : Content, message : Node, container : VBoxContainer, response : bool = false):
		message.load(content)
		container.add_child(message)
		
		if( response ):
			responses.append(message)
		
		await get_tree().process_frame
		scrollcontainer = container.get_parent()
		scrollbar = scrollcontainer.get_v_scroll_bar()
		scrollcontainer.scroll_vertical = scrollbar.max_value

func add_response(content : Content):
		if content.wid == "Doro":
			add(content, message_player.instantiate(), doro_chat_container)
			
		if content.wid == "Basti":
			add(content, message_player.instantiate(), basti_container)

func remove_response_buttons():
	for response in responses:
		response.queue_free()
	responses.clear()

func toggle_doro():
	doro_chat.show()
	basti_chat.hide()
	
func toggle_basti():
	basti_chat.show()
	doro_chat.hide()
