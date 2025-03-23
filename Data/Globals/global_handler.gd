extends Node
func fade_in_screen(screen: CanvasModulate, duration: float) -> void:
	var tween: Tween = create_tween()

	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(screen, "color", Color.BLACK, duration)
	
func fade_out_screen(screen: CanvasModulate, duration: float) -> void:
	var tween: Tween = create_tween()

	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(screen, "color", Color.WHITE, duration)
