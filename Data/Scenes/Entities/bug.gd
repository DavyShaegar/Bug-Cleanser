extends CharacterBody2D
class_name BugEnemy

@export_category("Enemy Stats")
@export var speed: float = 400.0
@export var health: float = 10.0
@export var rew_points: int = 0

# Enemy nodes
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Player

func set_target(target: Vector2) -> void:
	nav_agent.target_position = target

func _ready() -> void:
	player = get_node("../Player")
	set_target(player.global_position)

func _process(delta: float) -> void:
	look_at(player.global_position)
	
	if nav_agent.is_navigation_finished():
		return
		
	nav_agent.velocity = global_position.direction_to(nav_agent.get_next_path_position())
	move_and_slide()
