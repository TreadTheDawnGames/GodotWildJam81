extends "common.gd"

@export var sprite: Sprite2D
var _walk_timer: float = 0.0
var _to: Vector2
var _path: Array[Vector2]


func _state_init(data = null) -> void:
	_walk_timer = 0
	if data is Vector2:
		_path.push_back(data)
	elif data is Array[Vector2]:
		_path = data

	if !_path.is_empty():
		_to = _path.pop_front()


func _state_process(delta: float) -> String:
	_walk_timer += delta
	if _walk_timer >= 1.0:
		crewmate.position = _to
		return "Idle"
	return ""


func _state_transition(_new_state: String, _data = null) -> String:
	if !_path.is_empty():
		return "Walk"
	return ""
