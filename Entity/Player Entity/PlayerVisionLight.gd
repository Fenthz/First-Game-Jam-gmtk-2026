extends PointLight2D

@export_group("Vision Radius Settings")
@export var max_texture_scale: float = 7.0  #Scale at 100% time
@export var min_texture_scale: float = 0.5  #Scale at 0% time

@export_group("Vision Brightness Settings")
@export var max_energy: float = 1.0         #Brightness at 100% time
@export var min_energy: float = 0.3         #Brightness at 0% time

func _ready():
	GeneralSignals.time_changed.connect(_on_time_changed)

func _on_time_changed(_current_time, time_percent):
	texture_scale = lerp(min_texture_scale, max_texture_scale, time_percent)
	energy = lerp(min_energy, max_energy, time_percent)
