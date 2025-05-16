extends "common.gd"

@export var sprite: Sprite2D
var _walk_timer: float = 0.0
var _to: Vector2
var _path: Array[Vector2]
var _speed: float = 1.0


func _ready() -> void:
	_speed = 1.0 + randf() - 0.5


func _state_init(data: Dictionary) -> void:
	_walk_timer = 0
	if data.has("path"): _path = data["path"]
	if data.has("speed"): _speed = data["speed"]

	if !_path.is_empty():
		_to = _path.pop_front()


func _state_process(delta: float) -> Dictionary:
	_walk_timer += delta
	if _walk_timer >= 1.0 / _speed:
		crewmate.position = _to
		return {"new_state": "Work"}
	return {}


func _state_transition_(_data: Dictionary) -> Dictionary:
	if !_path.is_empty():
		return {"new_state": "Walk"}
	return {}
