extends Window

@export var task_button : Button

@export var content_lock : Node

@export var reports : ItemList
@export var history : ItemList

@export var username : Label
@export var post : RichTextLabel

@export var okay : Button
@export var delete : Button
@export var ban : Button

@onready var content_manager = %Content_Manager

signal on_notification_received

var content = []
var active : Content
var active_id = -1
var prefix = "Report 00"
var wait_time = 0
var wait_min = 1
var wait_max = 2
var wait_backup = [wait_min, wait_max]

func _ready():
	
	# Setup Lists
	reports.clear()
	reports.item_clicked.connect(self.select)
	reports.item_selected.connect(self.select)
	history.clear()
	
	# Setup Buttons
	okay.button_down.connect(okay_report)
	delete.button_down.connect(delete_report)
	ban.button_down.connect(ban_report)
	
	# Clear Example Content
	clear()
	
	# Overlay Locked State
	content_lock.show()


func load(new_content : Content):
	print("Process Report  " + new_content.id + ": " + new_content.text)
	var time = randf_range(wait_min, wait_max)
	wait_time += time
	await get_tree().create_timer(wait_time).timeout
	content.append(new_content)
	reports.add_item(prefix + new_content.id)
	wait_time -= time
	on_notification_received.emit()
	content_lock.hide()

func select(i : int):
	active_id = i
	active = content[i]
	username.text = active.uid
	post.text = active.text
	
	print("Select  Report  ", active.id)
	
	if(active.follow.size() > 0):
		print("Loading Report  ", active.id, " followers:")
		content_manager.load_content(active.follow[0], true)
		active.follow.clear()
	
	okay.show()
	delete.show()
	ban.show()
	
func okay_report():
	print("Allow   Report  ", active.id)
	if(active.buttons.size() > 0):
		content_manager.load_content(active.buttons[0], true)
	process_active()
	
func delete_report():
	print("Delete  Report  ", active.id)
	if(active.buttons.size() > 1):
		content_manager.load_content(active.buttons[1], true)
	process_active()
	
func ban_report():
	print("BanUser Report  ", active.id)
	if(active.buttons.size() > 2):
		content_manager.load_content(active.buttons[2], true)
	process_active()
	
func process_active():
	history.add_item(prefix +  active.id)
	reports.remove_item(active_id)
	content.remove_at(active_id)
	
	if reports.item_count > 0:
		select(0)
	else:
		clear()
	
func clear():
	username.text = ""
	post.text = ""
	okay.hide()
	delete.hide()
	ban.hide()

var debug = false
func _input(event):
	if event.is_action_released("debug"):
		debug = !debug
		if debug:
			print("ENABLE MOD WINDOW DEBUG")
			wait_min = 0
			wait_max = 0
		else:
			print("DISABLE MOD WINDOW DEBUG")
			wait_min = wait_backup[0]
			wait_max = wait_backup[1]
