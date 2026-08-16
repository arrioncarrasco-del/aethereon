class_name CrouchState
extends PlayerState


func enter(_previous_state: PlayerState = null) -> void:

	animation_controller.play("crouch")


func physics_update(_delta: float) -> void:

	if not Input.is_action_pressed("crouch"):

		var input := Input.get_vector(
			"move_left",
			"move_right",
			"move_forward",
			"move_backward"
		)

		if input.length() > 0.01:

			if Input.is_action_pressed("run"):
				state_machine.change_state("RunState")
			else:
				state_machine.change_state("WalkState")

		else:

			state_machine.change_state("IdleState")
