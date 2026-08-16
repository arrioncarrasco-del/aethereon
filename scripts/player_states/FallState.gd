class_name FallState
extends PlayerState


func enter(_previous_state: PlayerState = null) -> void:

	animation_controller.play("fall")


func physics_update(_delta: float) -> void:

	if player.is_on_floor():

		state_machine.change_state("LandState")
