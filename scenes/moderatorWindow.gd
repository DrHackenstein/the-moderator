extends Window

# Called when the node enters the scene tree for the first time.
func _ready():
	var count = 0
	var file = FileAccess.open("res://content/The Moderator - Act_1.csv", FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_csv_line ()
		count += 1
		if count > 1:
			var report = Report.new()
			report.id = line[0]
			report.text = line[1]
			report.uid = line[2]
			print("Added report: " + report.text)
	file.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
