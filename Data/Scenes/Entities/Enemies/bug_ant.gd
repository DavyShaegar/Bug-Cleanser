extends BugEnemy
class_name BugAnt

func  _ready() -> void:
	player = get_node("../Player")
	set_target(player.global_position)

func  _physics_process(delta: float) -> void:
	animate()
	if current_state == States.death: return
	moving(delta, player)

func _on_animation_animation_finished() -> void:
	if sprite.animation == "death":
		death()
