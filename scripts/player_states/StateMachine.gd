class_name StateMachine
extends Node

@export var initial_state: NodePath

var current_state: PlayerState
var states: Dictionary = {}

var player: CharacterBody3D
var data: PlayerData
var animation_controller: AnimationController


func setup(
	p_player: CharacterBody3D,
	p_data: PlayerData,
	p_animation_controller: AnimationController
) -> void:

	player = p_player
	data = p_data
	animation_controller = p_animation_controller

	_collect_states()

	for state in states.values():

		state.setup(
			player,
			data,
			animation_controller,
			self
		)

	var starting_state: PlayerState = null

	if initial_state != NodePath():
		starting_state = get_node_or_null(initial_state)

	if starting_state == null:
		starting_state = states.get("IdleState")

	if starting_state != null:
		change_state(starting_state.name)


func _collect_states() -> void:

	states.clear()

	for child in get_children():

		if child is PlayerState:
			states[child.name] = child


func change_state(state_name: String) -> void:

	if not states.has(state_name):
		push_error(
			"StateMachine: no existe el estado "
			+ state_name
		)
		return

	var next_state: PlayerState = states[state_name]

	if current_state == next_state:
		return

	var previous_state := current_state

	if current_state != null:
		current_state.exit(next_state)

	current_state = next_state
	current_state.enter(previous_state)


func _physics_process(delta: float) -> void:

	if current_state != null:
		current_state.physics_update(delta)


func _process(delta: float) -> void:

	if current_state != null:
		current_state.update(delta)
