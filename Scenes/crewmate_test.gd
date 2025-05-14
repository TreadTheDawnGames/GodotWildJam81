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
			crewmate.walk_to(mousepos)
			# var path = _pathfinding(from, to)
			# print(path)
			# _create_trail.call_deferred(path)
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
