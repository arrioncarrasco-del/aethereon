class_name PlayerController
extends CharacterBody3D

@export var data: PlayerData = PlayerData.new()

@onready var camera_pivot: Node3D = $CameraPivot
@onready var animation_controller: AnimationController = $AnimationController
@onready var state_machine: StateMachine = $StateMachine


var gravity: float
var camera_pitch: float = -10.0

var camera_yaw: float = 0.0


func _ready() -> void:

	gravity = (
		ProjectSettings.get_setting(
			"physics/3d/default_gravity"
		)
		* data.gravity_multiplier
	)

	_setup_input()

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	state_machine.setup(
		self,
		data,
		animation_controller
	)


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:

		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

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

	if event.is_action_pressed("ui_cancel"):

		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

			Input.set_mouse_mode(
				Input.MOUSE_MODE_VISIBLE
			)

		else:

			Input.set_mouse_mode(
				Input.MOUSE_MODE_CAPTURED
			)


func _physics_process(delta: float) -> void:

	_apply_gravity(delta)
	_apply_movement(delta)
	_rotate_player(delta)

	move_and_slide()


func _apply_gravity(delta: float) -> void:

	if not is_on_floor():

		velocity.y -= gravity * delta

	else:

		if velocity.y < 0.0:
			velocity.y = 0.0


func _apply_movement(delta: float) -> void:

	var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var input_direction := Vector3(
		input.x,
		0.0,
		input.y
	)

	var direction := (
		camera_pivot.global_transform.basis
		* input_direction
	)

	direction.y = 0.0
	direction = direction.normalized()

	var target_speed := data.walk_speed

	if state_machine.current_state != null:

		if state_machine.current_state.name == "RunState":

			target_speed = data.run_speed

		elif state_machine.current_state.name == "CrouchState":

			target_speed = data.crouch_speed

	if direction != Vector3.ZERO:

		velocity.x = move_toward(
			velocity.x,
			direction.x * target_speed,
			data.acceleration * delta
		)

		velocity.z = move_toward(
			velocity.z,
			direction.z * target_speed,
			data.acceleration * delta
		)

	else:

		velocity.x = move_toward(
			velocity.x,
			0.0,
			data.deceleration * delta
		)

		velocity.z = move_toward(
			velocity.z,
			0.0,
			data.deceleration * delta
		)


func _rotate_player(delta: float) -> void:

	var horizontal_velocity := Vector3(
		velocity.x,
		0.0,
		velocity.z
	)

	if horizontal_velocity.length_squared() < 0.01:
		return

	var target_rotation := atan2(
		horizontal_velocity.x,
		horizontal_velocity.z
	)

	rotation.y = lerp_angle(
		rotation.y,
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


func _add_key_action(
	action_name: String,
	key: Key
) -> void:

	if not InputMap.has_action(action_name):

		InputMap.add_action(action_name)

	var already_exists := false

	for existing_event in InputMap.action_get_events(action_name):

		if existing_event is InputEventKey:

			if existing_event.physical_keycode == key:

				already_exists = true
				break

	if already_exists:
		return

	var event := InputEventKey.new()

	event.physical_keycode = key

	InputMap.action_add_event(
		action_name,
		event
	)
