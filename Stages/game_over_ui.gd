extends CanvasLayer

@onready var control_root: Control = %Control
@onready var reason_label: Label = %Reason
@onready var restart_button: Button = %Restart
@onready var exit_button: Button = %Exit

func _ready():
	control_root.visible = false
	GeneralSignals.game_over.connect(_on_game_over)
	restart_button.pressed.connect(_on_restart_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_game_over(reason):
	reason_label.text = reason
	control_root.visible = true

func _on_restart_pressed():
	control_root.visible = false
	GameManager.restart_current_stage()
	
func _on_exit_pressed():
	GameManager.exit_current_stage()
