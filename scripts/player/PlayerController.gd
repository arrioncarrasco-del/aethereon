class_name PlayerController 
extends CharacterBody3D 
 
 
@export var data: PlayerData = PlayerData.new() 
 
 
@onready var camera_pivot: Node3D = $CameraPivot 
@onready var animation_controller: AnimationController = $PlayerModel/playerModel/AnimationController 
@onready var state_machine: StateMachine = $StateMachine 
@onready var player_model: Node3D = $PlayerModel 
 
 
var gravity: float = 0.0 
 
var camera_pitch: float = 0.0 
var camera_yaw: float = 0.0 
 
var movement_direction: Vector3 = Vector3.ZERO 
var movement_input: Vector2 = Vector2.ZERO 
 
 
func _ready() -> void: 
 
	_initialize_gravity() 
	_setup_input() 
 
	Input.set_mouse_mode( 
		Input.MOUSE_MODE_CAPTURED 
	) 
 
	state_machine.setup( 
		self, 
		data, 
		animation_controller 
	) 
 
 
func _initialize_gravity() -> void: 
 
	var default_gravity: float = ProjectSettings.get_setting( 
		"physics/3d/default_gravity" 
	) 
 
	gravity = ( 
		default_gravity 
		* data.gravity_multiplier 
	) 
 
 
func _unhandled_input(event: InputEvent) -> void: 
 
	if event.is_action_pressed("ui_cancel"): 
		_toggle_mouse_capture() 
 
	if event is InputEventMouseMotion: 
 
		_handle_mouse_look(event) 
 
	if event is InputEventKey: 
 
		if event.pressed and event.keycode == KEY_F1: 
 
			_toggle_mouse_capture() 
 
 
func _handle_mouse_look( 
	event: InputEventMouseMotion 
) -> void: 
 
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: 
 
		return 
 
	camera_yaw -= ( 
		event.relative.x 
		* data.mouse_sensitivity 
	) 
 
	camera_pitch -= ( 
		event.relative.y 
		* data.mouse_sensitivity 
	) 
 
	camera_pitch = clamp( 
		camera_pitch, 
		deg_to_rad(data.camera_pitch_min), 
		deg_to_rad(data.camera_pitch_max) 
	) 
 
	camera_pivot.rotation.y = camera_yaw 
	camera_pivot.rotation.x = camera_pitch 
 
 
func _physics_process(delta: float) -> void: 
 
	_update_movement_input() 
	_apply_gravity(delta) 
	_apply_movement(delta) 
	_rotate_player(delta) 
 
	move_and_slide() 
 
 
func _update_movement_input() -> void: 
 
	movement_input = Input.get_vector( 
		"move_left", 
		"move_right", 
		"move_forward", 
		"move_backward" 
	) 
 
	var input_direction := Vector3( 
		movement_input.x, 
		0.0, 
		movement_input.y 
	) 
 
	movement_direction = ( 
		camera_pivot.global_transform.basis 
		* input_direction 
	) 
 
	movement_direction.y = 0.0 
 
	if movement_direction.length_squared() > 0.0001: 
 
		movement_direction = ( 
			movement_direction.normalized() 
		) 
 
	else: 
 
		movement_direction = Vector3.ZERO 
 
 
func _apply_gravity(delta: float) -> void: 
 
	if is_on_floor(): 
 
		if velocity.y < 0.0: 
 
			velocity.y = 0.0 
 
		return 
 
	velocity.y -= gravity * delta 
 
	velocity.y = max( 
		velocity.y, 
		-data.terminal_velocity 
	) 
 
 
func _apply_movement(delta: float) -> void: 
 
	var target_speed := _get_target_speed() 
 
	var acceleration := data.acceleration 
	var deceleration := data.deceleration 
 
	if not is_on_floor(): 
 
		acceleration = data.air_acceleration 
		deceleration = data.air_deceleration 
 
	if movement_direction == Vector3.ZERO: 
 
		velocity.x = move_toward( 
			velocity.x, 
			0.0, 
			deceleration * delta 
		) 
 
		velocity.z = move_toward( 
			velocity.z, 
			0.0, 
			deceleration * delta 
		) 
 
		return 
 
	var target_velocity := ( 
		movement_direction 
		* target_speed 
	) 
 
	velocity.x = move_toward( 
		velocity.x, 
		target_velocity.x, 
		acceleration * delta 
	) 
 
	velocity.z = move_toward( 
		velocity.z, 
		target_velocity.z, 
		acceleration * delta 
	) 
 
 
func _get_target_speed() -> float: 
 
	if state_machine.current_state == null: 
 
		return data.walk_speed 
 
	match state_machine.current_state.name: 
 
		"RunState": 
 
			return data.run_speed 
 
		"CrouchState": 
 
			return data.crouch_speed 
 
		_: 
 
			return data.walk_speed 
 
 
func _rotate_player(delta: float) -> void: 
 
	if movement_direction.length_squared() < 0.0001: 
 
		return 
 
	var target_rotation := atan2( 
		movement_direction.x, 
		movement_direction.z 
	) 
 
	player_model.rotation.y = lerp_angle( 
		player_model.rotation.y, 
		target_rotation, 
		data.rotation_speed * delta 
	) 
 
 
func _setup_input() -> void: 
 
	_add_key_action( 
		"move_forward", 
		KEY_W 
	) 
 
	_add_key_action( 
		"move_backward", 
		KEY_S 
	) 
 
	_add_key_action( 
		"move_left", 
		KEY_A 
	) 
 
	_add_key_action( 
		"move_right", 
		KEY_D 
	) 
 
	_add_key_action( 
		"run", 
		KEY_SHIFT 
	) 
 
	_add_key_action( 
		"jump", 
		KEY_SPACE 
	) 
 
	_add_key_action( 
		"crouch", 
		KEY_CTRL 
	) 
 
	_add_key_action( 
		"interact", 
		KEY_E 
	) 
 
 
func _add_key_action( 
	action_name: String, 
	key: Key 
) -> void: 
 
	if not InputMap.has_action(action_name): 
 
		InputMap.add_action( 
			action_name 
		) 
 
	for existing_event in InputMap.action_get_events( 
		action_name 
	): 
 
		if existing_event is InputEventKey: 
 
			if existing_event.physical_keycode == key: 
 
				return 
 
	var event := InputEventKey.new() 
 
	event.physical_keycode = key 
 
	InputMap.action_add_event( 
		action_name, 
		event 
	) 
 
 
func _toggle_mouse_capture() -> void: 
 
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: 
 
		Input.set_mouse_mode( 
			Input.MOUSE_MODE_VISIBLE 
		) 
 
	else: 
 
		Input.set_mouse_mode( 
			Input.MOUSE_MODE_CAPTURED 
		)
