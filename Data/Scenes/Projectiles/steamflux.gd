extends GPUParticles2D
@onready var damage_tic: Timer = $DamageTic
@onready var damage_area: PackedScene = load("res://Data/Scenes/Projectiles/SteamDamage.tscn")

# store player damage here
@onready var damage: int = 1

func _process(delta: float) -> void:
	if emitting and damage_tic.is_stopped():
		damage_tic.start()
	elif emitting == false:
		damage_tic.stop()

func _on_damage_tic_timeout() -> void:
	var damage_insta = damage_area.instantiate()
	add_sibling(damage_insta)
	damage_insta.damage = damage
