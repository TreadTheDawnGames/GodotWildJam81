extends Node2D

func _ready() -> void:
	for connection : ConnectionMarker2D in get_children().filter(func(a): return a is ConnectionMarker2D):
		connection.LoadConnectionScene()
	return
