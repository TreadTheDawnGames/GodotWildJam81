### StateMachine
#   A finite state machine organized by child nodes

extends Node
class_name StateMachine

@export var _init_state: StateNode

var _init = false
var initialized: bool:
	get: return _init

@onready var __st: StateNode = _init_state
var current_state: String:
	get:
		return __st.name


func _ready() -> void:
	__st._state_init({})
	_init = true


### Executes the current state of the FSM
#   Within each state node, there must exist a function called `_state_process` that returns a string to a new state
func process_states(delta: float) -> void:
	transition(__st._state_process(delta))


### Transitions to a new state for the FSM
#	new_state: The state you want to transition to
func transition_old(new_state: String, data = null) -> void:
	return transition({"new_state": new_state, "data": data})


### Transitions to a new state for the FSM
#	data: Parameters for transitioning into a new state
func transition(data: Dictionary) -> void:
	if data.has("new_state"):
		var override: Dictionary = __st._state_transition(data)
		if !override.is_empty() && override.has("new_state"):
			__st = get_node(override["new_state"])
		else:
			__st = get_node(data["new_state"])
		__st._state_init(data)

#   Rage against the state machine
### - AoS 
