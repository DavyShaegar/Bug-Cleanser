extends Area2D
@onready var damage: int
@onready var direction: Vector2

func _ready() -> void:
	$TimeToLive.start()
	
func _process(delta: float) -> void:
	position += transform.x * 100 * delta

func _on_time_to_live_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is BugEnemy:
		body.get_hit(damage)
	else:
		queue_free()
