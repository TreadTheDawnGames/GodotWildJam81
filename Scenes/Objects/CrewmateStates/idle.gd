extends "common.gd"


func _state_process(_delta: float) -> Dictionary:
	var path = crewmate.create_path(crewmate.get_next_target())
	if path.is_empty():
		return {}
		
	return {
		"new_state": "Walk",
		"path": crewmate.create_path(crewmate.get_next_target())
	}
