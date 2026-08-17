extends Node

signal time_changed(current_time, time_percent)
signal time_expired
signal add_time_requested(amount)

signal game_over(reason)
signal stage_started(initial_time)

#Can modify to save the state of previous stage so that we can go back if
#game is ever updated to have that
signal stage_completed(next_stage_path)
