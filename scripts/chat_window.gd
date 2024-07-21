extends Window

@export var doro_avatar : Texture2D
@export var doro_avatar_notification : Texture2D
@export var basti_avatar : Texture2D
@export var basti_avatar_notification : Texture2D

@export var doro_button : Button
@export var basti_button : Button

@export var doro_chat : Control
@export var doro_chat_container : VBoxContainer
@export var basti_chat : Control
@export var basti_container : VBoxContainer

@export var task_button : Button

var id = "chat"
var message_player
var message_other
var message_response

var scrollbar
var scrollcontainer
var responses = []
var waiting_list = [0, 0]

var wait_min = 1
var wait_max = 3
var wait_backup = [wait_min, wait_max]

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
			wait_time = randf_range(wait_min, wait_max)
			waiting_list[0] += wait_time
			await get_tree().create_timer(waiting_list[0]).timeout
			add(content, message_other.instantiate(), doro_chat_container)
			waiting_list[0] -= wait_time
		"Basti":
			wait_time = randf_range(wait_min, wait_max)
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
		_:
			print("Couldn't match uid: " + content.uid + " for id " + content.id)

func add(content : Content, message : Node, container : VBoxContainer, response : bool = false):
		
		if debug:
			content.text = content.id + ": " + content.text
		
		message.load(content)
		container.add_child(message)
		
		if( response ):
			if responses.size() > 0 and responses[0].content.parent != message.content.parent:
				remove_response_buttons()
				
			responses.append(message)
		else:
			if ! has_focus() || ((content.uid == "Doro" && ! doro_chat.is_visible()) || (content.uid == "Basti" && ! basti_chat.is_visible()) ):
				if content.uid == "Doro":
					doro_button.set_button_icon(doro_avatar_notification)
				if content.uid == "Basti":
					basti_button.set_button_icon(basti_avatar_notification)
					
				task_button.set_notification( true )
		
		scrolldown(container)


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
	doro_button.set_button_icon(doro_avatar)
	scrolldown(doro_chat_container)
	
func toggle_basti():
	basti_chat.show()
	doro_chat.hide()
	basti_button.set_button_icon(basti_avatar)
	scrolldown(basti_container)

func scrolldown(container : VBoxContainer):
	await get_tree().process_frame
	scrollcontainer = container.get_parent()
	scrollbar = scrollcontainer.get_v_scroll_bar()
	scrollcontainer.scroll_vertical = scrollbar.max_value

func _process(delta):
	if has_focus():
		task_button.set_notification( false )
		if Globals.focus != id:
			Globals.focus = id
			if doro_chat.is_visible():
				doro_button.set_button_icon(doro_avatar)
			else:
				basti_button.set_button_icon(basti_avatar)

var debug = false
func _input(event):
	if event.is_action_released("debug"):
		debug = !debug
		if debug:
			print("ENABLE CHAT WINDOW DEBUG")
			wait_min = 0
			wait_max = 0
		else:
			print("DISABLE CHAT WINDOW DEBUG")
			wait_min = wait_backup[0]
			wait_max = wait_backup[1]
