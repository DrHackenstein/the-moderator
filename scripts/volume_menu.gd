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

func mute_music():
	is_music_muted = !is_music_muted
	AudioServer.set_bus_mute(music_mixer, is_music_muted)
	
	if !is_music_muted:
		music_mute_button.release_focus()

func mute_effects():
	is_effects_muted = !is_effects_muted
	AudioServer.set_bus_mute(effects_mixer, is_effects_muted)
	
	if !is_effects_muted:
		effects_mute_button.release_focus()

func change_music_volume(value):
	AudioServer.set_bus_volume_db(music_mixer, linear_to_db(value))
	music_volume_label.text = str(roundi(value * 5))

func change_effects_volume(value):
	AudioServer.set_bus_volume_db(effects_mixer, linear_to_db(value))
	effects_volume_label.text = str(roundi(value * 5))
