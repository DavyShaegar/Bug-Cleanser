extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -400.0
@onready var steam: CPUParticles2D = %Steam
@onready var gun_node: Node2D = $Gun

func _physics_process(delta: float) -> void:
	gun_node.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		steam.emitting = true
	elif Input.is_action_just_released("shoot"):
		steam.emitting = false
		
	var direction := Input.get_axis("move_left", "move_right")
	var y_dir := Input.get_axis("move_up", "move_down")
	if direction or y_dir:
		velocity.x = direction * (SPEED*10) * delta
		velocity.y = y_dir * (SPEED*10) * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)

	move_and_slide()
