extends Area2D
class_name TDCardPlayArea

@export
var _PlayType : String

func _ready() -> void:
	if(!_PlayType or _PlayType.length() <= 0):
		printerr("["+str(get_path())+"] PlayType not set. Card will not play properly when attempting to play here.")
	return

func GetPlayType() -> String: return _PlayType

func ValidPlayType(type : String) -> bool: return _PlayType.contains(type)
