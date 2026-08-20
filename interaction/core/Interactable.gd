class_name Interactable
extends Node


@export_category("Interaction")

@export var interaction_name: String = "Interactuar"

@export_multiline var interaction_description: String = ""

@export var enabled: bool = true


func can_interact(_interactor: CharacterBody3D) -> bool:
	return enabled


func get_interaction_name() -> String:
	return interaction_name


func get_interaction_description() -> String:
	return interaction_description


func interact(
	_interactor: CharacterBody3D
) -> InteractionResult:

	return InteractionResult.new(
		InteractionResult.Status.SUCCESS,
        "Interacción realizada."
	)
