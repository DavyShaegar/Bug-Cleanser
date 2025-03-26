extends MarginContainer

func _on_pausebutton_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	queue_free()
