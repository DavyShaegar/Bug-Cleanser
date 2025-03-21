extends BugEnemy
class_name BugAnt
@onready var attack_radius: Area2D = %AttackRadius
@onready var attack_target: CharacterBody2D

func radius_attack() -> void:
	for body in attack_radius.get_overlapping_bodies():
		if body is Player:
			look_at(body.global_position)
			set_state(States.attack)
			attack_target = body
			# Player takes damage when attack animation is finished

func  _ready() -> void:
	player = get_node("../Player")
	set_target(player.global_position)

func  _physics_process(delta: float) -> void:
	animate()
	if current_state == States.death: return
	moving(delta, player)
	radius_attack()

func _on_animation_animation_finished() -> void:
	if sprite.animation == "death":
		death()
	elif sprite.animation == "attack":
		melee_attack(attack_target)
