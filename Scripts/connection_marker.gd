extends Marker2D
class_name ConnectionMarker2D

var engine = preload("res://Scripts/engine.tscn")
var door = preload("res://Scripts/door_hatch.tscn")

func LoadConnectionScene():
	var totalRotation : int = int(global_rotation_degrees)
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
			printerr("Rotation is not correct for " + name, ": ", totalRotation)
	scene.position = Vector2.ZERO
	add_child(scene)
	return
