extends Node2D
class_name Crewmate

enum Alliance { ALLIANCE_NONE, ALLIANCE_PLAYER, ALLIANCE_ENEMY }

@export var state_machine: StateMachine
@export var alliance: Alliance
var _walk_pos: Vector2
var _path: Array[Vector2]

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)


func _ready() -> void:
	# Make sure to not await during _ready.
	actor_setup.call_deferred()
	

func actor_setup():
	# TODO: Set up _path
	
	pass


func _physics_process(delta: float) -> void:
	state_machine.process_states(delta)


func _debug_crewmate_test_changed_navpoint(pos: Vector2) -> void:
	_walk_pos = pos
	state_machine.transition("Walk", pos)


func check_for_valid_navigation(v: Vector2):
	pass
