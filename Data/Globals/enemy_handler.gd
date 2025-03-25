extends Node

# Use this to rank encounters (higher difficulties spawn more enemies)
@onready var difficulty_list: Dictionary[String, int] = {
														"Easy": 4, 
														"Medium": 8, 
														"Hard": 12, 
														"Insane": 20}
@onready var ant: PackedScene = load("res://Data/Scenes/Entities/Enemies/bug_ant.tscn")

func create_bug(bug: String) -> CharacterBody2D:
	var packBug: PackedScene
	
	match bug:
		"ant":
			packBug = ant
			
	return packBug.instantiate()
	
func get_rando_spawn_area(area: Area2D) -> Vector2:
	var rect: Vector2 = area.get_child(0).shape.extents # It's got only one child 
	var rect_pos: Vector2 = area.get_child(0).global_position
	
	var x_range: float = rect_pos.x + randf_range(-rect.x, rect.x)
	var y_range: float = rect_pos.y + randf_range(-rect.y, rect.y)
	
	return Vector2(x_range,y_range)

func create_encounter(bugs: Array, difficulty: String, spawn_area: Area2D, enemy_container: Node2D) -> void:
	var bugsNum: int = difficulty_list[difficulty]
	
	for i in range(bugsNum):
		var in_bug: CharacterBody2D = create_bug(bugs.pick_random())
		in_bug.global_position = get_rando_spawn_area(spawn_area)
		await get_tree().process_frame
		enemy_container.add_child(in_bug)
