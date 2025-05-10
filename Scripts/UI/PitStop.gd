extends Node2D

var marg : float

func _ready() -> void:
	marg = $Marker2D.global_position.distance_squared_to( global_position )
