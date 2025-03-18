extends CharacterBody2D
class_name Player

@export_category("Player Stats")
@export var speed: float = 500.0
@export var health: float = 100.0
@export var score: int = 0

enum States {
				idle,
				move,
				shoot,
				death 
			}
@onready var current_state: States = States.idle

# Player nodes
@onready var steam: GPUParticles2D = %Steam
@onready var gun_node: Node2D = $Gun

func change_state(new_state: States) -> void:
	if current_state == 2:
		return
	current_state = new_state
	
func shoot() -> void:
	steam.emitting = true
	change_state(States.shoot)

	if Input.is_action_pressed("shoot") == false:
		steam.emitting = false
		change_state(States.idle)
		
func _physics_process(delta: float) -> void:
	print(States.find_key(current_state))
	gun_node.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot"):
		shoot()
		
		
	var direction := Input.get_axis("move_left", "move_right")
	var y_dir := Input.get_axis("move_up", "move_down")
	if direction or y_dir:
		velocity.x = direction * (speed*10) * delta
		velocity.y = y_dir * (speed*10) * delta
		change_state(States.move)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		velocity.y = move_toward(velocity.y, 0, speed * delta)
		change_state(States.idle)

	move_and_slide()
