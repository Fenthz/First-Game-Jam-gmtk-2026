extends CharacterBody2D
class_name PlayerCharacter

@onready var aim_indicator: Line2D = $AimIndicator

const GRAVITY = 700.0
const SLING_MULTIPLIER = 4.0
const MAX_LAUNCH_SPEED = 800.0

const GROUND_LAYER_BIT = 1 << 0 
const ICE_LAYER_BIT    = 64 
#const HAZARD_LAYER_BIT = 1 << 2  

const BOUNCINESS_NORMAL = 0.75
const BOUNCINESS_ICE = 0.95
const FRICTION_NORMAL = 500.0
const FRICTION_ICE = 30.0
const STOP_THRESHOLD_NORMAL = 20.0
const STOP_THRESHOLD_ICE = 5.0

enum State { NORMAL, AIMING, STICKING }
enum DragMode { LAUNCH, STICK }

var current_state = State.NORMAL
var drag_mode = DragMode.LAUNCH

var is_on_ice: bool = false
var drag_start_pos = Vector2.ZERO

func _ready():
	if aim_indicator:
		aim_indicator.visible = false

func _physics_process(delta):
	match current_state:
		State.NORMAL:
			_process_movement(delta)
		State.STICKING:
			velocity = Vector2.ZERO
		State.AIMING:
			velocity = Vector2.ZERO
			_update_aim_indicator()
			
func _process_movement(delta: float):
	var current_friction = FRICTION_ICE if is_on_ice else FRICTION_NORMAL
	var current_bounciness = BOUNCINESS_ICE if is_on_ice else BOUNCINESS_NORMAL
	var current_stop_threshold = STOP_THRESHOLD_ICE if is_on_ice else STOP_THRESHOLD_NORMAL
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.x = move_toward(velocity.x, 0.0, current_friction * delta)
	var prev_velocity = velocity
	move_and_slide()
	_detect_surface_collisions()
	if drag_mode == DragMode.LAUNCH and get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		var normal = collision.get_normal()
		if not is_on_floor() or abs(prev_velocity.y) > 100.0:
			velocity = prev_velocity.bounce(normal) * current_bounciness
		
		
	if is_on_floor() and velocity.length() < current_stop_threshold:
		velocity = Vector2.ZERO
		
		
	if drag_mode == DragMode.STICK and (is_on_wall() or is_on_ceiling() or is_on_floor()):
		current_state = State.STICKING
		velocity = Vector2.ZERO
		
func _detect_surface_collisions():
	var standing_on_ice = false
			
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is TileMapLayer:
			var layer_bit = PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid())
			
			if layer_bit & ICE_LAYER_BIT:
				standing_on_ice = true
	is_on_ice = standing_on_ice
		
func _die_or_reset():
	print("Player hit a hazard tile!")
	# Add death / respawn logic here
		
func _unhandled_input(event):
	var is_fully_stopped = velocity.length() < 5.0
	var is_resting = is_on_floor() or current_state == State.STICKING
	
	if event.is_action_pressed("mouse_left") and is_fully_stopped and is_resting:
		drag_mode = DragMode.LAUNCH
		_start_aiming()
	elif event.is_action_pressed("mouse_right") and is_fully_stopped and is_resting:
		drag_mode = DragMode.STICK
		_start_aiming()
	
	if current_state == State.AIMING:
		if event.is_action_released("mouse_left") and drag_mode == DragMode.LAUNCH:
			launch_player()
		elif event.is_action_released("mouse_right") and drag_mode == DragMode.STICK:
			launch_player()
		
func _start_aiming():
	current_state = State.AIMING
	drag_start_pos = get_local_mouse_position()
	if aim_indicator:
		aim_indicator.visible = true
	
func _update_aim_indicator():
	if not aim_indicator:
		return
	
	var drag_current_pos = get_local_mouse_position()
	var launch_vector = drag_start_pos - drag_current_pos
	var max_visual_distance = MAX_LAUNCH_SPEED / SLING_MULTIPLIER
	var clamped_vector = launch_vector.limit_length(max_visual_distance)
		
	aim_indicator.clear_points()
	aim_indicator.add_point(Vector2.ZERO)
	aim_indicator.add_point(clamped_vector)
		
func launch_player():
	var drag_current_pos = get_local_mouse_position()
	var launch_vector = drag_start_pos - drag_current_pos
		
	velocity = (launch_vector * SLING_MULTIPLIER).limit_length(MAX_LAUNCH_SPEED)
		
	if aim_indicator:
		aim_indicator.visible = false
		
	current_state = State.NORMAL
