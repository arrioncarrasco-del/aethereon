class_name IdleState
extends PlayerState


func enter(_previous_state: PlayerState = null) -> void:

	animation_controller.play("idle")


func physics_update(_delta: float) -> void:

	if not player.is_on_floor():

		state_machine.change_state("FallState")
		return

	if Input.is_action_just_pressed("jump"):

		state_machine.change_state("JumpState")
		return

	if Input.is_action_pressed("crouch"):

		state_machine.change_state("CrouchState")
		return

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
