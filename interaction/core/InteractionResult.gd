class_name InteractionResult
extends RefCounted


enum Status {
	SUCCESS,
	FAILED,
	BLOCKED,
	CANCELLED
}


var status: Status
var message: String


func _init(
	p_status: Status,
	p_message: String = ""
) -> void:

	status = p_status
	message = p_message


func is_success() -> bool:
	return status == Status.SUCCESS
