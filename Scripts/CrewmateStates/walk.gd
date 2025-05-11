extends "common.gd"

@export var sprite: Sprite2D
var _walk_timer: float = 0.0
var _to: Vector2


func _state_init(data = null) -> void:
	_walk_timer = 0
	if data is Vector2:
		_to = data


func _state_process(delta: float) -> String:
	_walk_timer += delta
	if _walk_timer >= 1.0:
		crewmate.position = _to
		return "Idle"
	return ""
