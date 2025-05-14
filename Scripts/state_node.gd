### StateNode
#   An abstract class representing a state in the FSM

extends Node
class_name StateNode


func _state_init(data: Dictionary) -> void:
	pass


func _state_process(delta: float) -> Dictionary:
	return {}


func _state_transition(data: Dictionary) -> Dictionary:
	return {}


#   State your rights!
### - AoS
