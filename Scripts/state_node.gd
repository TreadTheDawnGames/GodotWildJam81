### StateNode
#   An abstract class representing a state in the FSM

extends Node
class_name StateNode


func _state_init(_data: Dictionary) -> void:
	pass


func _state_process(_delta: float) -> Dictionary:
	return {}


func _state_transition(_data: Dictionary) -> Dictionary:
	return {}


#   State your rights!
### - AoS
