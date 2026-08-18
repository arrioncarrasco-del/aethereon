class_name PlayerData
extends Resource


@export_category("Movement")

@export var walk_speed: float = 3.5
@export var run_speed: float = 6.5
@export var crouch_speed: float = 1.8

@export var acceleration: float = 18.0
@export var deceleration: float = 22.0


@export_category("Air Movement")

@export var air_acceleration: float = 8.0
@export var air_deceleration: float = 8.0


@export_category("Gravity")

@export var gravity_multiplier: float = 1.0
@export var terminal_velocity: float = 50.0


@export_category("Rotation")

@export var rotation_speed: float = 10.0


@export_category("Camera")

@export var mouse_sensitivity: float = 0.003
@export var camera_pitch_min: float = -55.0
@export var camera_pitch_max: float = 45.0


@export_category("Crouch")

@export var crouch_height: float = 1.0
