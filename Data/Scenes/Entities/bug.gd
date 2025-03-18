extends CharacterBody2D
class_name BugEnemy

@export_category("Enemy Stats")
@export var speed: float = 20.0
@export var health: float = 10.0
@export var rew_points: int = 0

# Enemy nodes
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Player

func navigate(nav: NavigationAgent2D, new_speed, delta):
	if !nav.is_navigation_finished():
		var direction = (nav.get_next_path_position() - global_position).normalized()
		
		translate(direction * new_speed * delta)
		look_at(direction)
		move_and_slide()
		
func set_target(target: Vector2) -> void:
	await get_tree().process_frame
	nav_agent.target_position = target
		
func animate() -> void:
	pass
	#animation.play(states.find_key(current_state))
	
func moving(delta) -> void:
	set_target(player.global_position)
	navigate(nav_agent, speed, delta)

func _ready() -> void:
	player = get_node("../Player")
	set_target(player.global_position)

func _process(delta: float) -> void:

	moving(delta)
		
