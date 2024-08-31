extends Node

@onready var mod_window : Window = %Mod_Window
@onready var chat_window : Window = %Chat_Window

var content = {}

var start = "1"
var scenarios = []
var scenario = ""

func _ready():
	start = Save_Controller.load_start(start)
	load_content_file()

func start_game():
	#Load Start Message
	load_content(content[start].id, true)

func load_content_file():
	var count = 0
	var file = FileAccess.open("res://content/content.csv.txt", FileAccess.READ)
	var data
	var start_id
	var skip = true
	
	if file == null:
		print("Couldn't load csv!")
		return
	
	while !file.eof_reached():
		
		data = file.get_csv_line ()
		
		#Skip headline
		if skip:
			skip = false
			continue
		
		#Read Line
		var line = Content.new()
		line.id = data[0]
		line.text = data[1]
		line.uid = data[2]
		line.wid = data[3]
		if data[4] != "":
			line.follow = data[4].split(",")
		if data[5] != "":
			line.buttons = data[5].split(",")
		line.okay = data[6] != "0"
		line.sid = data[7]
		line.trigger = data[8]
		if line.trigger == "start":
			scenarios.append(line.id)
		
		#Add line to content library
		content[ line.id ] = line
		
	file.close()

func load_content( id : String, follow : bool, parent : String = "" ):
	
	# Catch Loading Errors 
	if !content.has(id):
		print("Loading Content ", id, " FAILED (Parent=",parent,")")
		return
	else:
		print("Loading Content ", id)
	
	var content : Content = content[id]
	
	if content.trigger == "start":
		start = content.id
		Save_Controller.save_start(content.id)
	
	if content.trigger == "end" && content.follow.is_empty() && content.buttons.is_empty():
		Save_Controller.reset_saves()
	
	if parent != "":
		content.parent = parent
	
	#Inform Windows
	match content.wid:
		'Mod':
			mod_window.load(content)
		'Basti', 'Doro':
			chat_window.load(content)
			if content.uid == 'Player':
				follow = false
			else:
				follow = true
	
	#Load Follow Ups
	if follow && content.follow.size() > 0:
		print("Loading Content ", id, " Followers:")
		for i in content.follow:
			load_content( i, false, id )
		content.follow.clear()


