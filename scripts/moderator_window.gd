extends Window

@export var reports : ItemList
@export var history : ItemList

@export var username : Label
@export var post : RichTextLabel

@export var okay : Button
@export var delete : Button
@export var ban : Button

@onready var content_manager = %Content_Manager

var content = []
var active : Content
var active_id = -1
var prefix = "Report 00"

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
	
	clear()
	
	# Test
	#var test = Content.new()
	#test.text = "YEEES!"
	#test.uid = "Bernd"
	#test.id = "0001"
	#test.buttons = ["30","30","30"]
	#self.load(test)
	#
	#test = Content.new()
	#test.text = "NOOOOO!"
	#test.uid = "Beate"
	#test.id = "0002"
	#self.load(test)

func load(new_content : Content):
	print("Loading " + new_content.id)
	content.append(new_content)
	reports.add_item(prefix + new_content.id)

func select(i : int):
	print("Selected ", i)
	active_id = i
	active = content[i]
	username.text = active.uid
	post.text = active.text
	okay.show()
	delete.show()
	ban.show()
	
func okay_report():
	print("Okay")
	if(active.buttons.size() > 0):
		content_manager.load_content(active.buttons[0], true)
	process_active()
	
func delete_report():
	print("Delete")
	if(active.buttons.size() > 1):
		content_manager.load_content(active.buttons[1], true)
	process_active()
	
func ban_report():
	print("Ban")
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
