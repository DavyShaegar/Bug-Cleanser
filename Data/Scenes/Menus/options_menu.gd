extends MarginContainer
@onready var sfx_slider: HSlider = %SFXSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var mute_music: CheckButton = %MuteMusic

func _ready() -> void:

	sfx_slider.value = AudioServer.get_bus_volume_db(1)
	music_slider.value = AudioServer.get_bus_volume_db(2)
	mute_music.button_pressed = AudioServer.is_bus_mute(2)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	
func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)

func _on_mute_music_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		print("fullscreen")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		print("windowed")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
