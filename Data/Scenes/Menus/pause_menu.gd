extends MarginContainer

@onready var ambience: AudioStreamPlayer = %Ambience

## Copy because Globals is paused (don't want to create another global for paused)
func size_up_menu(menu: Control) -> void:
	var tween: Tween = create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(menu, "scale", Vector2.ONE, 0.25).from(Vector2.ZERO)
	
func resume() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	queue_free()
	
func _ready() -> void:
	size_up_menu(self)

# Resume game if player presses pause button
func _process(_delta: float) -> void:
#	if Input.is_action_just_pressed("pause"):
#		resume()
	pass

# Resume game
func _on_pausebutton_pressed() -> void:
	ambience.play()
	resume()

# Quit to main menu
func _on_quit_menu_pressed() -> void:
	ambience.play()
	get_tree().paused = false
	GlobalHandler.reset_game()
	get_tree().change_scene_to_file("res://Data/Scenes/Menus/main menu.tscn")

# Quit to desktop
func _on_quit_desktop_pressed() -> void:
	ambience.play()
	get_tree().paused = false
	get_tree().quit()
