extends Node2D
class_name Crewmate

enum Alliance { ALLIANCE_NONE, ALLIANCE_PLAYER, ALLIANCE_ENEMY }

@export var state_machine: StateMachine
@export var alliance: Alliance
@export var navigation_tilemap: TileMapLayer
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


func walk_to(target: Vector2) -> void:
	var from: Vector2i = navigation_tilemap.local_to_map(navigation_tilemap.to_local(position))
	var to: Vector2i = navigation_tilemap.local_to_map(navigation_tilemap.to_local(target))
	var arr: Array[Vector2i] = _pathfinding(from, to)
	var path: Array[Vector2]
	for i: Vector2i in arr:
		path.push_back(navigation_tilemap.map_to_local(i) * navigation_tilemap.scale)
	
	print(path)
	state_machine.transition("Walk", path)


### Depth-First Search ahh pathfinding
#
func _pathfinding(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	if (navigation_tilemap.get_cell_source_id(from) < 0):
		return []
	
	# Prepare the stack
	var path: Array[Vector2i]
	var stack: Array[Vector2i]
	stack.push_back(from)

	# Recursively find a path
	while !stack.is_empty():
		var v: Vector2i = stack.pop_back()
		path.push_back(v)	# Gets added to the line
		if v == to:
			path.pop_front()
			return path;

		# Push any of the unvisited cells into the node
		var surround: Array[Vector2i] = navigation_tilemap.get_surrounding_cells(v)
		var filtered: Array[Vector2i] = surround.filter(func(i): return navigation_tilemap.get_cell_source_id(i) >= 0 && !path.has(i))
		filtered.sort_custom(func(a, b): return a.distance_to(to) > b.distance_to(to))
		if !filtered.is_empty():
			filtered.all(func(i): stack.push_back(i); return true)

	return []
