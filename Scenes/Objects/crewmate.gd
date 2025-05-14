### Crewmate
# A simple AI-controlled crewmate that walks to wherever it's needed
# 
# Design guide:
#  - All public methods (the ones that don't start with an underscore)
#     must NOT change the state of the FSM!!! 
# - Events CAN change the state of the FSM

extends Node2D
class_name Crewmate

enum Alliance { ALLIANCE_NONE, ALLIANCE_PLAYER, ALLIANCE_ENEMY }

@export var state_machine: StateMachine
@export var alliance: Alliance
@export var navigation_tilemap: TileMapLayer
@export var navpoints: Node2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)


func _ready() -> void:
	$Sprite2D.position = (Vector2(randf(), randf()) - Vector2(.5, .5)) * 16.0
	

func _physics_process(delta: float) -> void:
	state_machine.process_states(delta)


func _debug_crewmate_test_changed_navpoint(pos: Vector2) -> void:
	state_machine.transition({
		"new_state": "Walk", 
		"path": [pos],
	})

func _walk_to(target: Vector2):
	var path = create_path(target)
	print(path)
	state_machine.transition({
		"new_state": "Walk", 
		"path": path,
	})
	

func get_next_target() -> Vector2:
	var c: Node2D = navpoints.get_child(randi_range(0, navpoints.get_child_count()-1))
	return c.position


func create_path(target: Vector2) -> Array[Vector2]:
	var from: Vector2i = navigation_tilemap.local_to_map(navigation_tilemap.to_local(position))
	var to: Vector2i = navigation_tilemap.local_to_map(navigation_tilemap.to_local(target))
	var arr: Array[Vector2i] = _pathfinding(from, to)
	var path: Array[Vector2]
	for i: Vector2i in arr:
		path.push_back(navigation_tilemap.map_to_local(i) * navigation_tilemap.scale)
	
	return path


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
