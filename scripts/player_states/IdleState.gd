class_name IdleState
extends PlayerState


func enter(_previous_state: PlayerState = null) -> void:

	animation_controller.play("idle")


func physics_update(_delta: float) -> void:

	# Si el jugador dejó el suelo, entra en caída.
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


	# Comprobar movimiento horizontal.
	var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)


	# Si no hay movimiento, permanece en Idle.
	if input.length() <= 0.01:

		return


	# Si está presionando correr, pasa a Run.
	if Input.is_action_pressed("run"):

		state_machine.change_state("RunState")

	else:

		state_machine.change_state("WalkState")
