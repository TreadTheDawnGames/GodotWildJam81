extends TDCard
class_name ShipPart

@export var engine : PackedScene
@export var door : PackedScene
var Connections : Array = []

func _ready():
	Connections = get_children(true).filter(func(a): return a is ConnectionMarker2D)
	print(Connections)
	Rotate()
	super._ready()
	return

func Rotate():
	global_position = get_global_mouse_position() + to_local((global_position - get_local_mouse_position()))
	for connection : Node in Connections:
		for child in connection.get_children():
			child.queue_free()
	
	var leftmostPosition : Vector2 = Connections[0].global_position
	for connection : Node2D in Connections:
		if(leftmostPosition.x > connection.global_position.x):
			leftmostPosition = connection.global_position
	
	for connection : ConnectionMarker2D in Connections:
		if(connection.global_position == leftmostPosition):
			var engineScene = engine.instantiate() as Node2D
			engineScene.position = Vector2.ZERO
			connection.add_child(engineScene)
		else:
			var doorScene = door.instantiate() as Node2D
			connection.add_child(doorScene)
	return


func UpdateWhichWall(targetPosition : Vector2):
	var nearestPosition : Vector2 
	var distToNear : float = INF

	for connection : Node2D in Connections:
		if(connection.global_position.distance_to(targetPosition) < distToNear):
			nearestPosition = connection.position
			distToNear = connection.global_position.distance_to(targetPosition)
	SetGoToOffset(nearestPosition)
	print(nearestPosition)

	return
