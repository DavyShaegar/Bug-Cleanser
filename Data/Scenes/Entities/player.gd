extends CharacterBody2D
class_name Player

@export_category("Player Stats")
@export var speed: float = 500.0
@export var health: float = 100.0
@export var score: int = 0


# Player nodes
@onready var steam: GPUParticles2D = %Steam
@onready var gun_node: Node2D = $Gun

# Other variables
@onready var mouse_pos: Vector2

func rotate_gun(mouse_pos: Vector2) -> void:
	var centre: Vector2 = global_position
	var angle: float = (mouse_pos - centre).angle()
	gun_node.position = Vector2(20,0).rotated(angle)
	
func shoot() -> void:
	if Input.is_action_pressed("shoot"):
		steam.emitting = true
	elif Input.is_action_just_released("shoot"):
		steam.emitting = false
		
func _physics_process(delta: float) -> void:
	mouse_pos = get_global_mouse_position()
	gun_node.look_at(mouse_pos)
	rotate_gun(mouse_pos)
	shoot()
		
	var direction := Input.get_axis("move_left", "move_right")
	var y_dir := Input.get_axis("move_up", "move_down")
	if direction or y_dir:
		velocity.x = direction * (speed*10) * delta
		velocity.y = y_dir * (speed*10) * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		velocity.y = move_toward(velocity.y, 0, speed * delta)

	move_and_slide()
