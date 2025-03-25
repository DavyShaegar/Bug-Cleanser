extends CanvasLayer

func _process(_delta: float) -> void:
	%Score.text = "Score: " + str(GlobalHandler.player_score)
