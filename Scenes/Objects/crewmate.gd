### Crewmate
# A simple AI-controlled crewmate that walks to wherever it's needed

extends Node2D
class_name Crewmate

enum Alliance { ALLIANCE_NONE, ALLIANCE_PLAYER, ALLIANCE_ENEMY }

@export var state_machine: StateMachine
@export var alliance: Alliance
@export var navigation_tilemap: ShipRoom
@export var navpoints: Node2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)
@export var processStates = true

var animSprite : AnimatedSprite2D
var xOffset : float

func _ready() -> void:
	if owner is ShipRoom: 
		navigation_tilemap = owner
		animSprite = $AnimatedSprite2D
		xOffset = (randf() - randf()) * 4
		$AnimatedSprite2D.position = Vector2(xOffset,5)# * 16.0
		navigation_tilemap.changed.connect(_on_nav_tilemap_changed)
		if(alliance == Alliance.ALLIANCE_ENEMY):
			modulate = Color.PURPLE



func _physics_process(delta: float) -> void:
	if(processStates):
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
	var s = navigation_tilemap.positionIndexedChildren.size()
	if s > 0:
		var v = navigation_tilemap.positionIndexedChildren.keys()[randi_range(0, s-1)]
		return navigation_tilemap.map_to_local(v)
	return position


func create_path(target: Vector2) -> Array[Vector2]:
	var from: Vector2i = navigation_tilemap.local_to_map(position)
	var to: Vector2i = navigation_tilemap.local_to_map(target)
	var arr: Array[Vector2i] = _pathfinding(from, to)
	var path: Array[Vector2]
	for i: Vector2i in arr:
		path.push_back(navigation_tilemap.map_to_local(i) * navigation_tilemap.scale)
	
	return path


### Depth-First Search ahh pathfinding
#
func _pathfinding(from: Vector2i, to: Vector2i) -> Array[Vector2i]:	
	if !navigation_tilemap.positionIndexedChildren.has(from):
		print("nav map doewn't have from")
		return[]
	if(navigation_tilemap.positionIndexedChildren.has(to) and is_instance_valid(navigation_tilemap.positionIndexedChildren[to]) and navigation_tilemap.positionIndexedChildren[to] is LaserCell):
		#print("trying to go to invalid tile")
		#trying to get to unnavigable tile
		return []
		
	# Prepare the stack
	var path: Array[Vector2i] = []
	var stack: Array[Vector2i] = []
	var con_cell: ConnectionCell = null
	stack.push_back(from)

	# A function that determines whether a given cell is accessible
	var filter_connected_rooms = func(c: Cell, i: Vector2i) -> bool:
		var neighbor = navigation_tilemap.positionIndexedChildren[i]
		if neighbor is ConnectionCell:
			return c.CanConnectTo(ConnectionCell.Direction.North, neighbor) || \
			c.CanConnectTo(ConnectionCell.Direction.South, neighbor) || \
			c.CanConnectTo(ConnectionCell.Direction.East, neighbor) || \
			c.CanConnectTo(ConnectionCell.Direction.West, neighbor)
		#print("assuming no")
		return false #assume you can't connect
	
	var prioritize_branches = func(a: Vector2i, b: Vector2i) -> bool:
		return a.distance_to(to) > b.distance_to(to)

	# Recursively find a path
	var attempts : int = 0
	while !stack.is_empty() and attempts < 50:
		var v: Vector2i = stack.pop_back()
		#print("trying to get to ", v)
		if navigation_tilemap.positionIndexedChildren.has(v):
			if(navigation_tilemap.positionIndexedChildren[v] is ConnectionCell):
				con_cell = navigation_tilemap.positionIndexedChildren[v]
				path.push_back(v)	# Gets added to the line
				if v == to:
					path.pop_front()
					return path;

				# Push any of the unvisited cells into the node
				var surround: Array[Vector2i] = con_cell.GetNeighborCells()
				var filtered: Array[Vector2i] = surround.filter(func(i): return filter_connected_rooms.call(con_cell, i))
				filtered.sort_custom(prioritize_branches)
				if !filtered.is_empty():
					filtered.all(func(i): stack.push_back(i); return true)
					attempts+=1
					#print("failed to find path")
	return []


func _on_nav_tilemap_changed():
	print("Navigation tilemap has changed!")
	pass
