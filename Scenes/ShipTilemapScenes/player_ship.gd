extends ShipRoom
class_name PlayerShip

static var grabbedRoom : ShipRoom = null

func _ready() -> void:
	dragNDrop = false
	super._ready()

func CombineParts(roomToAdd : ShipRoom, roomPosition : Vector2i):
	
	for cell : Cell in roomToAdd.positionIndexedChildren.values():
		if(positionIndexedChildren.has(cell.myCoords + roomPosition)):
			print("no go it's filled")
		pass
	for cell : Vector2i in roomToAdd.get_used_cells():
		set_cell(roomPosition + (roomPosition - cell), 0)
	return

func _process(_delta: float) -> void:
	
	return
