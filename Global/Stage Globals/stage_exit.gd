extends Area2D
class_name StageExit

@export_file("*.tscn") var next_stage_scene: String = ""

var is_triggered = false

func _ready():
	body_entered.connect(_on_body_entered)
	print("LevelTimer loaded with persistent time: ", GameManager.persistent_stage_time)

func _on_body_entered(body):
	$StageExitSfx.play()
	if is_triggered:
		return
		
	if body is PlayerCharacter or body.name == "PlayerCharacterBody2D":
		is_triggered = true
		GeneralSignals.stage_completed.emit(next_stage_scene)

func _transfer_stage_time():
	var level_timer: LevelTimer = get_tree().get_first_node_in_group("timer") as LevelTimer
	print("Saving time to GameManager: ", level_timer.time_left)
	if level_timer:
		GameManager.start_new_stage(level_timer.time_left)
