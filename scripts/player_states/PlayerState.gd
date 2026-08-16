class_name PlayerState
extends Node

var player: CharacterBody3D
var data: PlayerData
var animation_controller: AnimationController
var state_machine: StateMachine


func setup(
	p_player: CharacterBody3D,
	p_data: PlayerData,
	p_animation_controller: AnimationController,
	p_state_machine: StateMachine
) -> void:

	player = p_player
	data = p_data
	animation_controller = p_animation_controller
	state_machine = p_state_machine


func enter(_previous_state: PlayerState = null) -> void:
	pass


func exit(_next_state: PlayerState = null) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func update(_delta: float) -> void:
	pass
