extends Area2D
class_name Torch

@export_group("Torch Settings")
@export var time_to_add = 10.0
#Can also add a countdown??

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var light: PointLight2D = $PointLight2D

var is_collected: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	#Ignore collision if collected or if collided object isn't the player
	if is_collected or not (body.name == "PlayerCharacterBody2D" or body is CharacterBody2D):
		return
	_collect()

func _collect():
	is_collected = true
	$TorchSfx.play()
	GeneralSignals.add_time_requested.emit(time_to_add)
	print("Taken")
	collision_shape.set_deferred("disabled", true)
	visible = false
	#queue_free()
