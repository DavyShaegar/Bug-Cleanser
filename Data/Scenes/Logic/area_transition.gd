extends Node2D
@export_category("Where to? (Just one)")
@export var new_scene_destination: PackedScene
@export var new_position_destination: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		await get_tree().process_frame
		
		if new_scene_destination == null: # Teleport
			body.global_position = new_position_destination
		else: # Area Transition
			match name: # Handles special cases
				"EasyStart": # Dummy, for now
					GlobalHandler.set_game_to_easy_mode()
				"HardStart":
					GlobalHandler.set_game_to_hard_mode()
			
	
			get_tree().change_scene_to_packed(new_scene_destination)
