extends CharacterBody2D
class_name Player

@export_category("Player Stats")
@export var speed: float = 500.0
@export var health: float = 100.0

# Player nodes
@onready var steam: GPUParticles2D = %Steam
@onready var gun_node: Node2D = $Gun
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var pause_menu: PackedScene = load("res://Data/Scenes/Menus/pause_menu.tscn")

# Other variables
@onready var mouse_pos: Vector2

# States
enum States {
			idle,
			move,
			attack,
			death
			}
			
@onready var current_state: States = States.idle
func update_health_bar() -> void:
	%HealthBar.value = health
	
# This simulates recoil on the gun
func gun_shoot_shake() -> void:
	var randoPos: Vector2 = Vector2(randf_range(-4, 4), randf_range(-4, 4))
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Sprite2D, "position", $Sprite2D.position +randoPos, 0.1)
	
func set_state(new_state: States = States.idle) -> void:
	if current_state != new_state:
		current_state = new_state

func rotate_gun(mousePos: Vector2) -> void:
	rotate_gun_sprite(mousePos)
	var centre: Vector2 = global_position
	var angle: float = (mousePos - centre).angle()
	gun_node.position = Vector2(50,0).rotated(angle)
	
func rotate_gun_sprite(mousePos: Vector2) -> void:
	var centre: Vector2 = global_position
	var angle: float = (mousePos - centre).angle()
	$Sprite2D.look_at(mousePos)
	if $Sprite2D.global_rotation_degrees > 90 or $Sprite2D.global_rotation_degrees < -90:
		$Sprite2D.flip_v = true
	else: 
		$Sprite2D.flip_v = false
	$Sprite2D.position = Vector2(20,0).rotated(angle)
	
func shoot() -> void:
	if Input.is_action_pressed("shoot"):
		steam.emitting = true
		gun_shoot_shake()
	elif Input.is_action_just_released("shoot"):
		steam.emitting = false
		
func animate(mousePos: Vector2) -> void:
	if mousePos < global_position:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	sprite.play(States.find_key(current_state))

# Adds menu first, then pauses the engine. This way all the necessary functions will be processed
func pause() -> void:
	var in_pause: MarginContainer = pause_menu.instantiate()
	%UI.add_child(in_pause)
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
func _physics_process(delta: float) -> void:
	GlobalHandler.playerPos = global_position
	mouse_pos = get_global_mouse_position()
	animate(mouse_pos)

	if health <= 0:
		set_state(States.death)
		return
		
	gun_node.look_at(mouse_pos)
	rotate_gun(mouse_pos)
	shoot()
		
	var direction := Input.get_axis("move_left", "move_right")
	var y_dir := Input.get_axis("move_up", "move_down")
	if direction or y_dir:
		velocity.x = direction * (speed*10) * delta
		velocity.y = y_dir * (speed*10) * delta
		set_state(States.move)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		velocity.y = move_toward(velocity.y, 0, speed * delta)
		set_state(States.idle)
		
	if Input.is_action_just_pressed("pause"):
		pause()
		
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "death":
		get_tree().reload_current_scene()
