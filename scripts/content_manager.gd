class_name Content_Manager extends Node

@export var mod_window : Window
@export var chat_window : Window

var scenario = ""
var content = {}

func _ready():
	
	var count = 0
	var file = FileAccess.open("res://content/The Moderator - Act_1.csv", FileAccess.READ)
	var data
	var start_id
	var skip = true
	
	while !file.eof_reached():
		
		data = file.get_csv_line ()
		
		#Skip headline
		if skip:
			skip = false
			continue
			
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
		
		content[ line.id ] = line
		#print(line.text)
			
	file.close()
	
	self.load_content(content["1"].id, true)

func load_content( id : String, follow : bool, parent : String = "" ):
	
	# Catch Loading Errors 
	if !self.content.has(id):
		print("Couldn't find ", id)
		return
		
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
	if ( follow ):
		for i in content.follow:
			load_content( i, false, id )
	
	
