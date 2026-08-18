class_name InteractionData
extends Resource


@export_category("Interaction")

@export var action_name: String = "Interactuar"

@export_multiline var description: String = ""

@export var input_action: StringName = &"interact"

@export_category("Timing")

@export var requires_hold: bool = false

@export var hold_duration: float = 0.0
