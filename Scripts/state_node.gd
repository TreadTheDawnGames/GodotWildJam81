### StateNode
#   An abstract class representing a state in the FSM

extends Node
class_name StateNode


func _state_init(data = null) -> void:
	pass


func _state_process(delta: float) -> String:
	return ""


func _state_transition(new_state: String, data = null) -> String:
	return ""


#   State your rights!
### - AoS