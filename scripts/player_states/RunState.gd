class_name RunState
extends PlayerState


func enter(_previous_state: PlayerState = null) -> void:

	animation_controller.play("run")


func physics_update(_delta: float) -> void:

	# Si deja el suelo, entra en caída.
	if not player.is_on_floor():

		state_machine.change_state("FallState")
		return


	# Salto.
	if Input.is_action_just_pressed("jump"):

		state_machine.change_state("JumpState")
		return


	# Agacharse.
	if Input.is_action_pressed("crouch"):

		state_machine.change_state("CrouchState")
		return


	# Comprobar movimiento.
	var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)


	# Si deja de moverse, vuelve a Idle.
	if input.length() <= 0.01:

		state_machine.change_state("IdleState")
		return


	# Si deja de mantener Shift, vuelve a Walk.
	if not Input.is_action_pressed("run"):

		state_machine.change_state("WalkState")
