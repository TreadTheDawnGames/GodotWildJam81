### StateMachine
#   A finite state machine organized by child nodes

extends Node
class_name StateMachine

@export var _init_state: StateNode

@onready var __st: StateNode = _init_state
var current_state: String:
	get:
		return __st.name


func _ready() -> void:
	__st._state_init()


### Executes the current state of the FSM
#   Within each state node, there must exist a function called `_state_process` that returns a string to a new state
func process_states(delta: float) -> void:
	transition(__st._state_process(delta))


### Transitions to a new state for the FSM
#	new_state: The state you want to transition to
func transition(new_state: String, data = null) -> void:
	if !new_state.is_empty():
		var override: String = __st._state_transition(new_state, data)
		if override.is_empty():
			__st = get_node(new_state)
		else:
			__st = get_node(override)
		__st._state_init(data)

#   Rage against the state machine
### - AoS 
