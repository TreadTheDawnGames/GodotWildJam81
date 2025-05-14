extends ShipRoom
class_name PlayerShip

static var grabbedRoom : ShipRoom = null

func _ready() -> void:
	dragNDrop = false
	super._ready()

func CombineParts(roomToAdd : ShipRoom):
	DoCombine(roomToAdd)
	return
	
func DoCombine(roomToAdd : ShipRoom):
	roomToAdd.AddToMap(self)
	roomToAdd = null
		
		
	print("AttemptingToConnect")
	pass

func AbleToConnectPiece(roomToAdd : ShipRoom, roomPosition : Vector2i) -> bool:
	for cell : ConnectionCell in roomToAdd.positionIndexedChildren.values().filter(func(a): return a is ConnectionCell):
		var cellCoords : Vector2i = cell.myCoords + roomPosition
		if(positionIndexedChildren.has(cellCoords)):
			return false
		for neighbor in get_surrounding_cells(cellCoords):
			var neighborDirection : ConnectionCell.Direction = ConnectionCell.Direction.get(cell.DirectionStringFromVec2i(neighbor-cellCoords))
			if(positionIndexedChildren.has(neighbor)):
				if(cell.CanConnectTo(neighborDirection, GetChildByCoords(neighbor))):
					return true
	return false

func _process(_delta: float) -> void:
	
	return

func _draw():
	for item : Cell in positionIndexedChildren.values():
		item.queue_redraw()
