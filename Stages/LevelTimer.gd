extends Node
class_name LevelTimer

@export_group("Timer Config")
@export var max_time = 60.0
@export var starting_time = 60.0
@export var auto_start = true

var time_left = 0.0
var is_active = false

func _ready():
	GeneralSignals.add_time_requested.connect(add_time)
	GeneralSignals.stage_completed.connect(_on_stage_completed)
	starting_time = GameManager.persistent_stage_time
	time_left = min(starting_time, max_time)
	
	GameManager.stage_start_time = starting_time
	
	GeneralSignals.time_changed.emit(time_left, get_time_ratio())
	if auto_start:
		start_timer()
	
func _process(delta: float):
	if not is_active:
		return
	time_left -= delta
		
	if time_left <= 0.0:
		time_left = 0.0
		is_active = false
		GeneralSignals.time_changed.emit(time_left, 0.0)
		GeneralSignals.time_expired.emit()
		GeneralSignals.game_over.emit("Ran out of light")
	else:
		GeneralSignals.time_changed.emit(time_left, get_time_ratio())
		
func start_timer():
	is_active = true
		
func pause_timer():
	is_active = false
	
func add_time(amount: float):
	if time_left <= 0.0 and not is_active:
		return
		
	time_left = min(time_left + amount, max_time)
	GeneralSignals.time_changed.emit(time_left, get_time_ratio())
		
#ternary operator
func reset_timer(use_max: bool = false):
	time_left = max_time if use_max else starting_time
	GeneralSignals.time_changed.emit(time_left, get_time_ratio())
	#can delete start_timer() func to intantly make timer active once 
	#reset is called but this looks cleaner
	#is_active = true
	
func get_time_ratio():
	if max_time <= 0.0:
		return 0.0
	return clamp(time_left / max_time, 0.0, 1.0)
	
	
func _on_stage_completed(next_stage_path):
	#Save current time into GameManager
	GameManager.start_new_stage(time_left)
	#Tell GameManager to transition to the new stage
	GameManager.change_to_next_stage(next_stage_path)
