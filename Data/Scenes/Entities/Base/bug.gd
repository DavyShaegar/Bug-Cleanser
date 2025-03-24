extends CharacterBody2D
# This is the base class, all subclasses are different enemies
class_name BugEnemy

@export_category("State")
##States: idle, move, death
@export var current_state: States

@export_category("Enemy Stats")
@export var speed: float
@export var health: float
@export var damage: int
@export var reward_points: int

# Enemy nodes
@export_category("Enemy Nodes")
@export var sprite: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D
@export var player: Player
@export var blood: PackedScene
@export var audio_player: AudioStreamPlayer2D

# Sounds
@export_category("Sounds Data")
@export var audio_death_list: Array[AudioStreamMP3]
@export var attack_sound: AudioStreamMP3
@export var walk_sound: AudioStreamMP3

# States
enum States {
			idle,
			move,
			attack,
			death
			}
			
func set_state(new_state: States = States.idle) -> void:
	if current_state != new_state and current_state != States.death:
		current_state = new_state
		
func play_sound() -> void:
	if !audio_player.is_playing():
		
		match current_state:
			States.move:
				audio_player.stream = walk_sound
			States.attack:
				pass
			States.death:
				audio_player.stream = audio_death_list.pick_random()
						
		audio_player.play()

func navigate(nav: NavigationAgent2D, new_speed, delta) -> void:
	if !nav.is_navigation_finished():
		var direction = (nav.get_next_path_position() - global_position).normalized()
		
		translate(direction * new_speed * delta)
		look_at(nav.get_next_path_position())
		move_and_slide()
		set_state(States.move)
		play_sound()
	else:
		nav_agent.target_position = position
		velocity = Vector2(0,0)
		set_state(States.idle)
		
func set_target(target: Vector2) -> void:
	await get_tree().process_frame
	nav_agent.target_position = target
		
func animate() -> void:
	sprite.play(States.find_key(current_state))
	
func moving(delta, target) -> void:
	if nav_agent.distance_to_target() > 300.0:
		nav_agent.target_position = position
		return 
	set_target(target.global_position)
	navigate(nav_agent, speed, delta)

func get_hit(incoming_damage: int) -> void:
	if current_state == States.death:
		return
		
	health -= incoming_damage
	var in_blood = blood.instantiate()
	add_child(in_blood)
	in_blood.emitting = true
	
	if health <= 0:
		set_state(States.death)
		audio_player.stop()
		play_sound()
		
		GlobalHandler.reward_player_score(reward_points, global_position)


func death() -> void:
	await get_tree().create_timer(1.0).timeout # Remove later
	queue_free()

func melee_attack(attack_target: CharacterBody2D) -> void:
	if attack_target.current_state == States.death:
		return
	attack_target.health -= damage
	print(attack_target.health)
