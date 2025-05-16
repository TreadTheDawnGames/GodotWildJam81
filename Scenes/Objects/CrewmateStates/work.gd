extends "common.gd"

const MAX_WORK_TIME: float = 3.0

var _flash: bool = false
var _worktime: float = MAX_WORK_TIME

func _state_init(_data: Dictionary) -> void:
	_flash = false
	_worktime = MAX_WORK_TIME + randf_range(0.0, 1.0)
	pass


func _state_process(delta: float) -> Dictionary:
	_flash = !_flash
	crewmate.modulate = Color.RED if _flash else Color.WHITE
	_worktime -= delta
	if _worktime < 0.0:
		return {"new_state": "Idle"}
	return {}


func _state_transition(_data: Dictionary) -> Dictionary:
	_flash = false
	crewmate.modulate = Color.WHITE
	return {}
