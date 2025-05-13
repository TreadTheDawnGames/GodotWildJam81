extends TDCard
class_name ShipPart

@export var engine : PackedScene
@export var door : PackedScene
@onready var non_rotator: Marker2D = $NonRotator
@export var price : int
@export var partName : String

### A collection of ConnectionMarker2Ds
var Connections : Array = []

func _ready():
	Data = ShipRoomData.new(name, "ShipPart")
	SetUp(Data, true)
	SetUsable(true)
	Connections = get_children(true).filter(func(a): return a is ConnectionMarker2D)
	Rotate(false)
	print(usable)
	#global_position = global_position.snapped(Vector2(32,32))
	return

func _DragDropLogic(delta : float):
	super._DragDropLogic(delta)
	#global_position = global_position.snapped(Vector2(32,32))
	return

func Rotate(doRotate : bool = true):
	if(doRotate):
		rotate(deg_to_rad(90))
		non_rotator.rotate(deg_to_rad(-90))
		global_position = get_global_mouse_position() 
		if(rotation_degrees >= 360):
			rotation_degrees = 0
		if(non_rotator.rotation_degrees <= -360):
			non_rotator.rotation_degrees = 0
	
	for connection : Node in Connections:
		for child in connection.get_children():
			child.queue_free()
	
	for connection : ConnectionMarker2D in Connections:
		connection.LoadConnectionScene()
	return


func UpdateWhichWall(targetPosition : Vector2):
	SetGoToOffset(non_rotator.to_local(targetPosition.round()))
	return
