extends Node
# Add this to whatever particle emitter that need to get queued_freed 
# Connect the signal as well
func _on_finished() -> void:
	queue_free()
