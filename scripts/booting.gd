extends Popup

@export var background : ColorRect
@export var progress_spinner : TextureProgressBar
@export var audio_player : AudioStreamPlayer
@export var text : Label

func _ready() -> void:
	setup_spinner()
	setup_audio()
	self.popup_window = false
	
	await get_tree().create_timer(3).timeout
	text.show()
	progress_spinner.show()
	
func setup_spinner():
	var tween: Tween = get_tree().create_tween().set_loops()
	tween.tween_property(progress_spinner, "radial_initial_angle", 360.0, 1.5).as_relative()

func setup_audio():
	audio_player.finished.connect(close)
	audio_player.play()
	
func close():
	text.hide()
	progress_spinner.hide()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(background, "color", Color.TRANSPARENT, 0.3)
	
	await get_tree().create_timer(1).timeout
	%Music_Player.play()
	await get_tree().create_timer(1).timeout
	%Mod_Window.show()
	await get_tree().create_timer(1).timeout
	%Guideline.show()
	%Content_Manager.start_game()
	
	queue_free()
