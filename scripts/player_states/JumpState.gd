class_name JumpState
extends PlayerState


func enter(_previous_state: PlayerState = null) -> void:

	player.velocity.y = data.jump_velocity

	animation_controller.play("jump")


func physics_update(_delta: float) -> void:

	if player.velocity.y <= 0.0:

		state_machine.change_state("FallState")
