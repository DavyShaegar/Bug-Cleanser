extends CanvasLayer

func _process(delta: float) -> void:
	%Score.text = "Score: " + str(GlobalHandler.player_score)
