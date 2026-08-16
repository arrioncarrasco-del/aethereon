class_name AnimationController
extends Node

@export var animation_player_path: NodePath

var animation_player: AnimationPlayer


func _ready() -> void:
	_find_animation_player()


func _find_animation_player() -> void:

	if animation_player_path != NodePath():
		animation_player = get_node_or_null(animation_player_path)

	if animation_player == null:
		animation_player = _search_animation_player(self)

	if animation_player == null:
		push_error("AnimationController: No se encontró AnimationPlayer.")


func _search_animation_player(node: Node) -> AnimationPlayer:

	for child in node.get_children():

		if child is AnimationPlayer:
			return child

		var result := _search_animation_player(child)

		if result != null:
			return result

	return null


func play(animation_name: String, blend_time: float = 0.15) -> void:

	if animation_player == null:
		return

	var animation := _find_animation(animation_name)

	if animation == "":
		push_warning(
			"AnimationController: no existe la animación: "
			+ animation_name
		)
		return

	if animation_player.current_animation == animation:
		return

	animation_player.play(animation, blend_time)


func stop() -> void:

	if animation_player != null:
		animation_player.stop()


func has_animation(animation_name: String) -> bool:

	if animation_player == null:
		return false

	return animation_player.has_animation(animation_name)


func _find_animation(requested_name: String) -> String:

	if animation_player == null:
		return ""

	if animation_player.has_animation(requested_name):
		return requested_name

	var aliases := {
		"idle": [
			"idle",
			"Idle",
			"mixamo.com"
		],

		"walk": [
			"walk",
			"Walk"
		],

		"run": [
			"run",
			"Run"
		],

		"jump": [
			"jump",
			"Jump"
		],

		"fall": [
			"fall",
			"Fall",
			"landing",
			"Landing"
		],

		"land": [
			"land",
			"Land",
			"landing",
			"Landing"
		],

		"crouch": [
			"crouch",
			"crouching",
			"Crouch",
			"Crouching"
		]
	}

	if aliases.has(requested_name):

		for candidate in aliases[requested_name]:

			if animation_player.has_animation(candidate):
				return candidate

	return ""
