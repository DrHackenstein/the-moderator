class_name Content_Manager extends Node

@export var mod_window : Window
@export var chat_window : Window

var scenario = ""
var content = {}

func _ready():
	
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
		line.follow = data[4].split(",")
		line.buttons = data[5].split(",")
		line.okay = data[6] != "0"
		line.sid = data[7]
		line.trigger = data[8]
		
		#Add line to content library
		content[ line.id ] = line
		#print(line.text)
			
	file.close()
	
	#Load Start Message
	self.load_content(content["1"].id, true)
	#self.load_content(content["M2b"].id, true)
	#self.load_content(content["E1"].id, true)

func load_content( id : String, follow : bool, parent : String = "" ):
	
	# Catch Loading Errors 
	if !content.has(id):
		print("Couldn't find ", id, " (Parent=",parent,")")
		return
	
	print("Loading ", id)
	
	var content = self.content[id]
	
	if parent != "":
		content.parent = parent
	
	#Inform Windows
	match content.wid:
		'Mod':
			self.mod_window.load(content)
		'Basti', 'Doro':
			self.chat_window.load(content)
			if content.uid == 'Player':
				follow = false
			else:
				follow = true
	
	#Load Follow Ups
	if follow && content.follow.size() > 0:
		print("Loading follows of ", id, ":")
		for i in content.follow:
			load_content( i, false, id )
	
	
