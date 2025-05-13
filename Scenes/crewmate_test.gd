extends Node2D

var current_navpoint: Marker2D

@onready var crewmate: Crewmate = $Crewmate
@onready var label: Label = $Label
@onready var camera: Camera2D = $Camera2D
@onready var tilemap: TileMapLayer = $TileMapLayer
@export var trail_texture: Texture2D

var _trail: Node2D

signal changed_navpoint(pos: Vector2)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_up"):
			current_navpoint = $NavPoint1
			changed_navpoint.emit(current_navpoint.position)
		if event.is_action_pressed("ui_right"):
			current_navpoint = $NavPoint2
			changed_navpoint.emit(current_navpoint.position)
		if event.is_action_pressed("ui_down"):
			current_navpoint = $NavPoint3
			changed_navpoint.emit(current_navpoint.position)
		if event.is_action_pressed("ui_left"):
			current_navpoint = $NavPoint4
			changed_navpoint.emit(current_navpoint.position)
	
	if event is InputEventMouse:
		if event.is_action_pressed("AOS.debug_left_click"):
			var mousepos = Global.mouse_position_to_local(event, camera)
			label.text = str(mousepos)
			var from: Vector2i = _global_to_tilemap(crewmate.position)
			var to: Vector2i = _global_to_tilemap(mousepos)
			var path = _pathfinding(from, to)
			print(path)
			_create_trail.call_deferred(path)
		pass


func _create_trail(path):
	if _trail:
		_trail.queue_free()
	_trail = Node2D.new()
	for i: Vector2i in path:
		var sp: Sprite2D = Sprite2D.new()
		sp.texture = trail_texture
		sp.scale = 0.1 * Vector2.ONE
		sp.position = tilemap.map_to_local(i) * tilemap.scale
		_trail.add_child(sp)
	add_child(_trail)


func _global_to_tilemap(v: Vector2) -> Vector2i:
	return tilemap.local_to_map(tilemap.to_local(v))


### Depth-First Search ahh pathfinding
func _pathfinding(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	if (tilemap.get_cell_source_id(from) < 0):
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
			return path;

		# Push any of the unvisited cells into the node
		var surround: Array[Vector2i] = tilemap.get_surrounding_cells(v)
		var filtered: Array[Vector2i] = surround.filter(func(i): return tilemap.get_cell_source_id(i) >= 0 && !path.has(i))
		filtered.sort_custom(func(a, b): return a.distance_to(to) > b.distance_to(to))
		if !filtered.is_empty():
			filtered.all(func(i): stack.push_back(i); return true)

	return []
