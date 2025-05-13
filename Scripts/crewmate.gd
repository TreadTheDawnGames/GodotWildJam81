extends Node2D
class_name Crewmate

enum Alliance { ALLIANCE_NONE, ALLIANCE_PLAYER, ALLIANCE_ENEMY }

@export var state_machine: StateMachine
@export var alliance: Alliance
@export var _navigation_agent: NavigationAgent2D:
	get:
		return _nav_agent
	set(value):
		_nav_agent = value

var _nav_agent: NavigationAgent2D
var _walk_pos: Vector2


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	state_machine.process_states(delta)


func _debug_crewmate_test_changed_navpoint(pos: Vector2) -> void:
	_walk_pos = pos
	state_machine.transition("Walk", pos)


func check_for_valid_navigation(v: Vector2):
	pass