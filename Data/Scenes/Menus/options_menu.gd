extends MarginContainer
@onready var sfx_slider: HSlider = %SFXSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var mute_music: CheckButton = %MuteMusic

# Store here which control we are changing
@onready var key_selected: LineEdit

func _unhandled_input(event: InputEvent) -> void:
	print(event.as_text())
	if key_selected != null:
		key_selected.text = event.as_text()
		
		# Removes the previous action and adds the new one
		InputMap.action_erase_events(key_selected.name)
		InputMap.action_add_event(key_selected.name, event)
		
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		key_selected.release_focus()
		key_selected = null

func _ready() -> void:
	sfx_slider.value = AudioServer.get_bus_volume_db(1)
	music_slider.value = AudioServer.get_bus_volume_db(2)
	mute_music.button_pressed = AudioServer.is_bus_mute(2)
	
	for child in %ControlList.get_children(true):
		for ChildofChild in child.get_children(): # :))))))))) 
			if ChildofChild is LineEdit:
				var event: Array[InputEvent] = InputMap.action_get_events(ChildofChild.name)
				ChildofChild.text = event[0].as_text().split(" ")[0]

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
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_ctrl_up_focus_entered() -> void:
	key_selected = %move_up
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_ctrl_down_focus_entered() -> void:
	key_selected = %move_down
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_ctrl_left_focus_entered() -> void:
	key_selected = %move_left
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_ctrl_right_focus_entered() -> void:
	key_selected = %move_right
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_ctrl_attack_focus_entered() -> void:
	key_selected = %shoot
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _on_ctrl_pause_focus_entered() -> void:
	key_selected = %pause
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resolution_item_selected(index: int) -> void:
	var new_res: Vector2 
	match index:
		0: # 1080p
			new_res = Vector2(1920, 1080)
		1: #720p
			new_res = Vector2(1280, 720)
			
	DisplayServer.window_set_size(new_res)
