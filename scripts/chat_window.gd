extends Window

@export var task_button : Button

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

signal on_notification_received

var message_player
var message_other
var message_other_typing
var message_response

var scrollbar
var scrollcontainer
@onready var containers = [doro_chat_container, basti_container]
var responses = []
var waiting_times = [0, 0]
var typing_messages = [null, null]

var wait_min_mod = 0.25
var wait_max_mod = 0.7
var wait_backup = [wait_min_mod, wait_max_mod]

func _ready():
	doro_button.button_down.connect(toggle_doro)
	basti_button.button_down.connect(toggle_basti)
	
func load_message_nodes():
	if message_other == null:
		message_other = load("res://scenes/chat_messages_other.tscn")
		
	if message_player == null:
		message_player = load("res://scenes/chat_messages_player.tscn")
		
	if message_response == null:
		message_response = load("res://scenes/chat_messages_player_button.tscn")
		
	if message_other_typing == null:
		message_other_typing = load("res://scenes/chat_messages_other_typing.tscn")

func load(content : Content):
	print("Process Message " + content.id + ": " + content.text)
	await get_tree().create_timer(0.5).timeout
	
	load_message_nodes()
	
	match content.uid:
		"Doro":
			load_message_others(0, content)
			
		"Basti":
			load_message_others(1, content)
			
		"Player":
			match content.wid:
				"Doro":
					await get_tree().create_timer(waiting_times[0]+1.5).timeout
					display_message(content, message_response.instantiate(), doro_chat_container, true)
			
				"Basti":
					await get_tree().create_timer(waiting_times[1]+1.5).timeout
					display_message(content, message_response.instantiate(), basti_container, true)
		_:
			print("Process Message " + content.id + ": FAILED! Couldn't match uid: " + content.uid)

func load_message_others(id : int, content : Content):
	var wait_time = content.text.split(" ").size() * randf_range(wait_min_mod, wait_max_mod)
	if ! debug:
		wait_time += 1
	
	waiting_times[id] += wait_time
	
	await get_tree().create_timer(waiting_times[id] - wait_time + 0.5).timeout
	add_typing(id)
	await get_tree().create_timer(wait_time - 0.5).timeout
	remove_typing(id)
	
	display_message(content, message_other.instantiate(), containers[id])
	waiting_times[id] -= wait_time

func display_message(content : Content, message : Node, container : VBoxContainer, response : bool = false):
		
		message.load(content, debug)
		container.add_child(message)
		
		if( response ):
			# Remove Previous responses
			if responses.size() > 0 and responses[0].content.parent != message.content.parent:
				remove_response_buttons()
			
			responses.append(message)
		else:
			if ! has_focus() || ((content.uid == "Doro" && ! doro_chat.is_visible()) || (content.uid == "Basti" && ! basti_chat.is_visible()) ):
				if content.uid == "Doro":
					doro_button.set_button_icon(doro_avatar_notification)
				if content.uid == "Basti":
					basti_button.set_button_icon(basti_avatar_notification)
				on_notification_received.emit()
		
		scrolldown(container)

func add_typing( id : int ):
	typing_messages[id] = message_other_typing.instantiate()
	containers[id].add_child( typing_messages[id] )
	scrolldown(containers[id])

func remove_typing(id : int):
	typing_messages[id].queue_free()

func add_response_text(content : Content):
		if content.wid == "Doro":
			display_message(content, message_player.instantiate(), doro_chat_container)
			
		if content.wid == "Basti":
			display_message(content, message_player.instantiate(), basti_container)

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
	await get_tree().process_frame
	scrollcontainer = container.get_parent()
	scrollbar = scrollcontainer.get_v_scroll_bar()
	scrollcontainer.scroll_vertical = scrollbar.max_value

func _process(delta):
	if has_focus():
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
			wait_min_mod = 0.1
			wait_max_mod = 0.1
		else:
			print("DISABLE CHAT WINDOW DEBUG")
			wait_min_mod = wait_backup[0]
			wait_max_mod = wait_backup[1]
