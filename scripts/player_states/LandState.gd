class_name LandState
extends PlayerState

var landing_timer: float = 0.0
var landing_duration: float = 0.25


func enter(_previous_state: PlayerState = null) -> void:

	landing_timer = 0.0

	animation_controller.play("land")


func physics_update(delta: float) -> void:

	landing_timer += delta

	if landing_timer >= landing_duration:

		var input := Input.get_vector(
			"move_left",
			"move_right",
			"move_forward",
			"move_backward"
		)

		if input.length() <= 0.01:

			state_machine.change_state("IdleState")

		elif Input.is_action_pressed("run"):

			state_machine.change_state("RunState")

		else:

			state_machine.change_state("WalkState")
