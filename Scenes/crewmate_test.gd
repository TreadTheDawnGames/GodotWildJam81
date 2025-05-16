extends Node2D

var current_navpoint: Marker2D

@onready var crewmate: Crewmate = $Crewmate
@onready var label: Label = $Label
@onready var camera: Camera2D = $Camera2D
@onready var tilemap: TileMapLayer = $TileMapLayer
@export var trail_texture: Texture2D

var _trail: Node2D

signal changed_navpoint(pos: Vector2)

func _input(event: InputEvent) -> void:
	
	var _scroll: bool = false
	if event is InputEventMouse:
		_scroll = false
		if event.is_action_pressed("click"):
			var mousepos = Global.mouse_position_to_local(event, camera)
			label.text = str(mousepos)
			crewmate._walk_to(mousepos)
			# var path = _pathfinding(from, to)
			# print(path)
			# _create_trail.call_deferred(path)
	if event is InputEventMouseMotion && _scroll:
		camera.position += event.velocity / 1.0


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
