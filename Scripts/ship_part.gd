extends TDCard
class_name ShipPart

@export var engine : PackedScene
@export var door : PackedScene
@onready var non_rotator: Marker2D = $NonRotator

var Connections : Array = []

func _ready():
	Data = ShipRoomData.new(name, "ShipPart")
	SetUp(Data, true)
	SetUsable(true)
	Connections = get_children(true).filter(func(a): return a is ConnectionMarker2D)
	Rotate(false)
	print(usable)
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
		var totalRotation : int = int(connection.global_rotation_degrees)
		@warning_ignore("integer_division")
		var timesRotated : int = totalRotation/90
		if(timesRotated > 0):
			totalRotation = totalRotation / abs(timesRotated)

		var scene
		if(totalRotation > -5 and totalRotation < 5):
			scene = engine.instantiate() as ConnectionPlayArea
			scene.SetCardinalWall(ConnectionPlayArea.WallDirection.west)
		else:
			scene = door.instantiate() as ConnectionPlayArea
			if(totalRotation > 85 and totalRotation < 95):
				scene.SetCardinalWall(ConnectionPlayArea.WallDirection.north)
			elif(totalRotation < -85 and totalRotation > -95):
				scene.SetCardinalWall(ConnectionPlayArea.WallDirection.south)
			elif(abs(totalRotation) > 175 and abs(totalRotation) < 185):
				scene.SetCardinalWall(ConnectionPlayArea.WallDirection.east)
			else:
				printerr("Rotation is not correct for " + connection.name, ": ", totalRotation)
		
			print(connection.name, ": ", totalRotation)
		scene.position = Vector2.ZERO
		connection.add_child(scene)
	return


func UpdateWhichWall(targetPosition : Vector2):
	SetGoToOffset(non_rotator.to_local(targetPosition))
	return
