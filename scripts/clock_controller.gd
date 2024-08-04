extends HBoxContainer

@export var timer : Timer
@export var label : Label

var hour = 22
var minute = 1
var text

func _ready():
	timer.timeout.connect(add_minute)
	
	var start_values = Save_Controller.load_time(hour, minute)
	hour = start_values[0]
	minute = start_values[1]
	
	update_label()

func add_minute():
	minute += 1
	
	if minute == 60:
		minute = 0
		hour += 1
	
	if hour == 24:
		hour = 0
	
	Save_Controller.save_time(hour, minute)
	update_label()


func update_label():
	if hour < 10 : text = "0" + str(hour)
	else: text = str(hour)
	
	text += ":"
	
	if minute < 10 : text += "0" + str(minute)
	else: text += str(minute)
	
	label.text = text

