extends "common.gd"


func _state_process(delta: float) -> Dictionary:
	if crewmate.navpoints:
		return {
			"new_state": "Walk",
			"path": crewmate.create_path(crewmate.get_next_target())
		}
	return {}
