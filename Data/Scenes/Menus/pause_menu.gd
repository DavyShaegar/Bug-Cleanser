extends MarginContainer
## Copy because Globals is paused (don't want to create another global for paused)
func size_up_menu(menu: Control) -> void:
	var tween: Tween = create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(menu, "scale", Vector2.ONE, 0.25).from(Vector2.ZERO)
	
func _ready() -> void:
	size_up_menu(self)
	
func _on_pausebutton_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	queue_free()

func _on_quit_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Data/Scenes/Menus/main menu.tscn")

func _on_quit_desktop_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
