class_name JumpState
extends PlayerState


func enter(_previous_state: PlayerState = null) -> void:

	animation_controller.play("jump")


func physics_update(_delta: float) -> void:

	if animation_controller.is_animation_finished():

		_finish_jump()


func _finish_jump() -> void:

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
