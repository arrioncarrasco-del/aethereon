class_name InteractionSystem
extends Node


signal interaction_available(
	interactable: Interactable
)

signal interaction_unavailable

signal interaction_started(
	interactable: Interactable
)

signal interaction_finished(
	result: InteractionResult
)




@export_category("Detection")

@export var interaction_ray_path: NodePath

@export var interaction_distance: float = 3.0


var player: CharacterBody3D
var ray: RayCast3D

var current_interactable: Interactable = null


func _ready() -> void:

	player = get_parent() as CharacterBody3D

	if player == null:

		push_error(
			"InteractionSystem: el nodo padre debe ser CharacterBody3D."
		)

		return

	_find_ray()


func _find_ray() -> void:

	if interaction_ray_path != NodePath():

		ray = get_node_or_null(
			interaction_ray_path
		)

	if ray == null:

		ray = player.get_node_or_null(
			"CameraPivot/SpringArm3D/Camera3D/InteractionRay"
		)

	if ray == null:

		push_error(
			"InteractionSystem: no se encontró InteractionRay."
		)


func _process(_delta: float) -> void:

	if ray == null:
		return

	_update_detection()
	_check_input()


func _update_detection() -> void:

	var detected := _get_interactable()

	if detected == current_interactable:
		return

	if current_interactable != null:

		current_interactable = null

		interaction_unavailable.emit()

	if detected != null:

		current_interactable = detected

		interaction_available.emit(
			current_interactable
		)

		print(
			"Interactuable detectado: ",
			current_interactable.get_interaction_name()
		)


func _get_interactable() -> Interactable:

	if not ray.is_colliding():
		return null

	var collider := ray.get_collider()

	if collider is Node:

		var node := collider as Node

		while node != null:

			if node is Interactable:

				var interactable := node as Interactable

				if interactable.can_interact(player):

					return interactable

				return null

			node = node.get_parent()

	return null


func _check_input() -> void:

	if current_interactable == null:
		return

	if Input.is_action_just_pressed("interact"):

		print("[INTERACTION] E PRESIONADA")

		_execute_interaction()

func _execute_interaction() -> void:

	if current_interactable == null:
		return

	print(
		"[INTERACTION] Ejecutando: ",
		current_interactable.get_interaction_name()
	)

	if not current_interactable.can_interact(player):
		print("[INTERACTION] Interacción bloqueada")
		return

	print("[INTERACTION] Interacción iniciada")

	interaction_started.emit(
		current_interactable
	)

	var result := current_interactable.interact(
		player
	)

	print(
		"[INTERACTION] Resultado: ",
		result
	)

	interaction_finished.emit(
		result
	)
