extends Control

@onready var screen: CanvasModulate = %ScreenFade
# True if buttons can be interacted with (prevents multiple clicks and when buttons are moving)
@onready var menu_interaction: bool = false

# Initial Positions
@onready var start_sPos: Vector2 = %Start.position
@onready var options_sPos: Vector2 = %Options.position
@onready var exit_sPos: Vector2 = %Exit.position
@onready var optionsMenu_sPos: Vector2 = %OptionsMenu.position
@onready var spawnPoints: Array[Marker2D] = [%EnemySpawn_left, %EnemySpawn_down, %EnemySpawn_right]
#region Menus Handler
func smooth_ui_movement(node: Control, finalPos: Vector2, duration: float) -> void:
	var tween: Tween = create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "position", finalPos, duration)

func move_buttons_to_position() -> void:
	for button in $Buttons.get_children():
		# Moves the button to their normal positions
		await get_tree().create_timer(0.25).timeout
		smooth_ui_movement(button, get_node("%"+button.name+"Pos").position, 1.0)

# Just an ad hoc function for moving out buttons :D
func get_current_button_destination(button: Control) -> Vector2:
	if button.name == "Start":
		return start_sPos
	elif button.name == "Options":
		return options_sPos
	else:
		return exit_sPos
		
func move_buttons_out() -> void:
	for button in $Buttons.get_children():
		# Moves the button to their normal positions
		await get_tree().create_timer(0.1).timeout
		smooth_ui_movement(button, get_current_button_destination(button), 1.0)
		
func move_options_menu_in() -> void:
	await get_tree().create_timer(0.2).timeout
	smooth_ui_movement(%OptionsMenu, %OptionMenuPos.position, 1.0)
	menu_interaction = true
	
func move_options_menu_out() -> void:
	await get_tree().create_timer(0.2).timeout
	smooth_ui_movement(%OptionsMenu, optionsMenu_sPos, 1.0)
	menu_interaction = true
	
#endregion

func add_decoration_entities() -> void:
	for i in range(10):
		var spawn: Marker2D = spawnPoints.pick_random()
		var instance_bug = EnemyHandler.create_bug("ant")
		instance_bug.global_position = spawn.global_position
		instance_bug.scale = Vector2(4,4)
		await get_tree().create_timer(randf()).timeout
		%DecorationEnemies.add_child(instance_bug)

func _ready() -> void:
	randomize()
	GlobalHandler.fade_out_screen(screen, 1.0)
	move_buttons_to_position()
	
	await get_tree().create_timer(2.0).timeout
	add_decoration_entities()
	menu_interaction = true
	
func _on_start_pressed() -> void:
	if menu_interaction == true:
		menu_interaction = false
		
		move_buttons_out()
		GlobalHandler.fade_in_screen(screen, 0.5)
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Data/Scenes/testscene.tscn")
		
func _on_options_pressed() -> void:
	if menu_interaction == true:
		menu_interaction = false
		
		move_buttons_out()
		move_options_menu_in()
	
func _on_exit_pressed() -> void:
	if menu_interaction == true:
		menu_interaction = false
		
		GlobalHandler.fade_in_screen(screen, 1.0)
		await get_tree().create_timer(1.5).timeout
		get_tree().quit()

func _on_options_back_pressed() -> void:
	if menu_interaction == true:
		menu_interaction = false

	move_buttons_to_position()
	move_options_menu_out()
	
## WIP
func _on_options_apply_pressed() -> void:
	pass # Replace with function body.
