extends Node2D

func delete_encounter(trigger: Area2D, spawner: Area2D) -> void:
		await get_tree().process_frame
		trigger.queue_free()
		
		## Delete also spawner maybe? 5 seconds is for safety
		await get_tree().create_timer(5.0).timeout
		spawner.queue_free()

func _on_encounter_trigger_01_body_entered(body: Node2D) -> void:
	if body is Player:
		EnemyHandler.create_encounter(["ant"], "Insane", %Spawner_01, %Enemies)
	delete_encounter(%EncounterTrigger_01 ,%Spawner_01)
