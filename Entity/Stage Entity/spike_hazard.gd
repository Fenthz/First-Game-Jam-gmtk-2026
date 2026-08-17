extends Area2D
class_name SpikeHazard

@export var cause_of_death: String = "Impaled by spikes"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is PlayerCharacter or body.name == "PlayerCharacterBody2D":
		GeneralSignals.game_over.emit(cause_of_death)
		
