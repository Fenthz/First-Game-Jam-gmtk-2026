extends Node
var persistent_stage_time: float = 30.0
var stage_start_time: float = 30.0

func _ready():
	GeneralSignals.game_over.connect(_on_game_over)
	GeneralSignals.stage_completed.connect(change_to_next_stage)
	
func start_new_stage(starting_time):
	persistent_stage_time = starting_time
	stage_start_time = starting_time

func restart_current_stage():
	get_tree().paused = false
	get_tree().reload_current_scene()

func exit_current_stage():
	get_tree().quit()
	
func change_to_next_stage(next_stage_path: String) -> void:
	get_tree().paused = false
	if next_stage_path != "" and ResourceLoader.exists(next_stage_path):
		get_tree().change_scene_to_file.call_deferred(next_stage_path)
	else:
		print("Warning: Next stage path is invalid or empty!")

func _on_game_over(_reason):
	get_tree().paused = true
