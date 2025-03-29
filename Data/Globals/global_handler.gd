extends Node

@onready var player_score: int = 0
@onready var playerPos: Vector2

# Use this for harcore mode (1.0 normal game, 2 harcore)
@onready var player_score_multiplier: int = 1

@onready var floating_score: PackedScene = load("res://Data/Scenes/Decoration/floating_score.tscn")

func wobble_floating_text(text_node: Label) -> void:
	var tween: Tween = create_tween()
	var randoPos: Vector2 = Vector2(10.0, -4.0)

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	var tween_alpha: Tween = create_tween()
	tween_alpha.set_trans(Tween.TRANS_LINEAR)
	tween_alpha.set_ease(Tween.EASE_IN)
	tween_alpha.tween_property(text_node, "modulate", Color(1, 1, 1, 0), 2)
	
	for i in range(10):
		tween.tween_property(text_node, "global_position", text_node.global_position + randoPos, 0.2)
		if i %2 == 1:
			randoPos += Vector2(10.0, -4.0)
		else:
			randoPos += Vector2(-10.0, -4.0)
	
func size_up_menu(menu: Control) -> void:
	var tween: Tween = create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(menu, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)
	
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

func reward_player_score(score: int, position:Vector2) -> void:
	add_score(score)
	show_floating_score(score, position)

func add_score(score: int) -> void:
	player_score += score * player_score_multiplier
	
func show_floating_score(score: int, position: Vector2) -> void:
	var in_floating_score: Label = floating_score.instantiate()
	in_floating_score.global_position = position
	in_floating_score.text = "+ " + str(score * player_score_multiplier) + "!"
	add_child(in_floating_score)
	wobble_floating_text(in_floating_score)

func set_game_to_hard_mode() -> void:
	player_score_multiplier = 2
	
func set_game_to_easy_mode() -> void: # Dummy for now
	pass
	
func reset_game() -> void:
	player_score = 0
	player_score_multiplier = 2
