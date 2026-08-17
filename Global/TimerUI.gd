extends CanvasLayer

@onready var timer_label: Label = %TimerLabel

func _ready():
	GeneralSignals.time_changed.connect(_on_time_changed) #general_signals.gd
	GeneralSignals.time_expired.connect(_on_time_expired)

func _on_time_changed(current_time, _time_percent):
	#var minutes: int = int(current_time) / 60
	#var seconds: int = int(current_time) % 60
	timer_label.text = "%0.1fs" % current_time

func _on_time_expired():
	timer_label.text = "00s"
