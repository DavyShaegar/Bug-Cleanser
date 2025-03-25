extends Node2D

func delete_encounter(trigger: Area2D, spawner: Area2D) -> void:
		await get_tree().process_frame
		trigger.queue_free()
		
		## Delete also spawner maybe?
		await get_tree().create_timer(1.0).timeout
		spawner.queue_free()

func _on_encounter_trigger_01_body_entered(body: Node2D) -> void:
	if body is Player:
		EnemyHandler.create_encounter(["ant"], "Easy", %Spawner_01, %Enemies)
	delete_encounter(%EncounterTrigger_01 ,%Spawner_01)
