extends GPUParticles2D
@onready var damage_tic: Timer = $DamageTic
@onready var damage_area: PackedScene = load("res://Data/Scenes/Projectiles/SteamDamage.tscn")
@onready var audio_player: AudioStreamPlayer2D = %AudioPlayer

@onready var audio_list: Array[AudioStreamMP3] = [	load("res://Data/Audio/Sfx/steam_flux_1.mp3"),
													load("res://Data/Audio/Sfx/steam_flux_2.mp3")
													]

# store player damage here
@onready var damage: int = 1
func _ready() -> void:
	# Randomizes the audio
	audio_player.stream = audio_list.pick_random()

func _process(_delta: float) -> void:
	if emitting and damage_tic.is_stopped():
		
		# Plays only once :)
		if audio_player.is_playing() == false:
			audio_player.play()
			
		damage_tic.start()
		
	elif emitting == false:
		# Stops the audio and randomizes it again
		audio_player.stop()
		audio_player.stream = audio_list.pick_random()
		
		damage_tic.stop()

func _on_damage_tic_timeout() -> void:
	var damage_insta = damage_area.instantiate()
	add_sibling(damage_insta)
	damage_insta.damage = damage
