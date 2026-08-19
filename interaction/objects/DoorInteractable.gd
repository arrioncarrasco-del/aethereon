class_name DoorInteractable
extends Interactable


@export_category("Door")
@export var animation_player: AnimationPlayer

@export_category("Settings")
@export var starts_open: bool = false
@export var locked: bool = false


enum DoorState {
	CLOSED,
	OPENING,
	OPEN,
	CLOSING
}


var state: DoorState = DoorState.CLOSED


func _ready() -> void:

	if animation_player == null:
		animation_player = _find_animation_player(self)

	if animation_player == null:
		push_error(
			"DoorInteractable: No se encontró AnimationPlayer."
		)
		return

	if starts_open:
		state = DoorState.OPEN
		animation_player.play("open")
		animation_player.advance(
			animation_player.current_animation_length
		)


func _find_animation_player(
	node: Node
) -> AnimationPlayer:

	for child in node.get_children():

		if child is AnimationPlayer:
			return child

		var result := _find_animation_player(child)

		if result != null:
			return result

	return null


func get_interaction_name() -> String:

	if locked:
		return "Bloqueada"

	match state:

		DoorState.CLOSED:
			return "Abrir puerta"

		DoorState.OPEN:
			return "Cerrar puerta"

		DoorState.OPENING:
			return "Abriendo..."

		DoorState.CLOSING:
			return "Cerrando..."

	return "Interactuar"


func can_interact(
	_interactor: Node
) -> bool:

	if locked:
		return false

	return (
		state == DoorState.CLOSED
		or state == DoorState.OPEN
	)


func interact(
	_interactor: Node
) -> InteractionResult:

	if locked:

		return InteractionResult.new(
			InteractionResult.Status.BLOCKED,
			"Puerta bloqueada."
		)

	if animation_player == null:

		return InteractionResult.new(
			InteractionResult.Status.FAILED,
			"No se encontró AnimationPlayer."
		)

	match state:

		DoorState.CLOSED:

			_open()

			return InteractionResult.new(
				InteractionResult.Status.SUCCESS,
				"Puerta abierta."
			)

		DoorState.OPEN:

			_close()

			return InteractionResult.new(
				InteractionResult.Status.SUCCESS,
				"Puerta cerrada."
			)

	return InteractionResult.new(
		InteractionResult.Status.FAILED,
		"La puerta está ocupada."
	)


func _open() -> void:

	state = DoorState.OPENING

	animation_player.play("open")


func _close() -> void:

	state = DoorState.CLOSING

	animation_player.play("close")


func _on_animation_finished(
	animation_name: StringName
) -> void:

	match animation_name:

		"open":
			state = DoorState.OPEN

		"close":
			state = DoorState.CLOSED
