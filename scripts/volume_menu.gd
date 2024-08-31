extends Popup

@export var music_mute_button : Button
@export var music_volume_slider : Slider
@export var music_volume_label : Label

@export var effects_mute_button : Button
@export var effects_volume_slider : Slider
@export var effects_volume_label : Label

@onready var music_mixer = AudioServer.get_bus_index("Music")
@onready var effects_mixer = AudioServer.get_bus_index("Effects")

var is_music_muted = false
var is_effects_muted = false


func _ready():
	music_mute_button.button_up.connect(mute_music)
	music_volume_slider.value_changed.connect(change_music_volume)
	
	effects_mute_button.button_up.connect(mute_effects)
	effects_volume_slider.value_changed.connect(change_effects_volume)
	
	load_music_volume()
	load_effects_volume()

func load_music_volume():
	var loaded = Save_Controller.load_music_volume(0.5, false)
	music_volume_slider.value = loaded[0]
	if loaded[1]:
		music_mute_button.emit_signal("button_up")
		music_mute_button.set_pressed_no_signal(true)

func load_effects_volume():
	var loaded = Save_Controller.load_effects_volume(0.5, false)
	effects_volume_slider.value = loaded[0]
	if loaded[1]:
		effects_mute_button.emit_signal("button_up")
		effects_mute_button.set_pressed_no_signal(true)
		
func mute_music():
	is_music_muted = !is_music_muted
	AudioServer.set_bus_mute(music_mixer, is_music_muted)
	Save_Controller.save_music_volume(music_volume_slider.value, is_music_muted)
	
	if !is_music_muted:
		music_mute_button.release_focus()

func mute_effects():
	is_effects_muted = !is_effects_muted
	AudioServer.set_bus_mute(effects_mixer, is_effects_muted)
	Save_Controller.save_effects_volume(effects_volume_slider.value, is_effects_muted)
	
	if !is_effects_muted:
		effects_mute_button.release_focus()

func change_music_volume(value):
	AudioServer.set_bus_volume_db(music_mixer, linear_to_db(value))
	music_volume_label.text = str(roundi(value * 5))
	Save_Controller.save_music_volume(value, is_music_muted)

func change_effects_volume(value):
	AudioServer.set_bus_volume_db(effects_mixer, linear_to_db(value))
	effects_volume_label.text = str(roundi(value * 5))
	Save_Controller.save_effects_volume(value, is_effects_muted)
