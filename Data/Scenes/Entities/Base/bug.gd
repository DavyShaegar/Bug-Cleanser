extends CharacterBody2D
# This is the base class, all subclasses are different enemies
class_name BugEnemy

@export_category("State")
##States: idle, move, death
@export var current_state: States

@export_category("Enemy Stats")
@export var speed: float
@export var health: float
@export var reward_points: int

# Enemy nodes
@export_category("Enemy Nodes")
@export var sprite: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D
@export var player: Player
@export var blood: PackedScene

# States
enum States {
			idle,
			move,
			death
			}
			
func set_state(new_state: States = States.idle) -> void:
	if current_state != new_state and current_state != States.death:
		current_state = new_state

func navigate(nav: NavigationAgent2D, new_speed, delta) -> void:
	if !nav.is_navigation_finished():
		var direction = (nav.get_next_path_position() - global_position).normalized()
		
		translate(direction * new_speed * delta)
		look_at(nav.get_next_path_position())
		move_and_slide()
		set_state(States.move)
	else:
		set_state(States.idle)
		
func set_target(target: Vector2) -> void:
	await get_tree().process_frame
	nav_agent.target_position = target
		
func animate() -> void:
	sprite.play(States.find_key(current_state))
	
func moving(delta, target) -> void:
	if nav_agent.distance_to_target() > 300.0:
		nav_agent.target_position = self.position
		return 
	set_target(target.global_position)
	navigate(nav_agent, speed, delta)

func get_hit(damage) -> void:
	health -= damage
	var in_blood = blood.instantiate()
	add_child(in_blood)
	in_blood.emitting = true
	
	if health <= 0:
		print("dead")
		set_state(States.death)

func death() -> void:
	queue_free()
