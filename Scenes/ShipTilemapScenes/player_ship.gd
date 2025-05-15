extends ShipRoom
class_name PlayerShip

static var grabbedRoom : ShipRoom = null

func _ready() -> void:
	dragNDrop = false
	#super._ready()
	Setup.call_deferred()
	
func DoCombine(roomToAdd : ShipRoom):
	roomToAdd.AddToMap(self)
	roomToAdd = null
	pass

func AbleToConnectPiece(roomToAdd : ShipRoom, roomPosition : Vector2i) -> bool:
	var able : bool = false
	for cell : ConnectionCell in roomToAdd.positionIndexedChildren.values().filter(func(a): return a is ConnectionCell):
		var cellCoords : Vector2i = cell.myCoords + roomPosition
		if(HasCell(cellCoords)):
			return false
		for neighbor in get_surrounding_cells(cellCoords):
			var neighborDirection : ConnectionCell.Direction = ConnectionCell.Direction.get(cell.DirectionStringFromVec2i(neighbor-cellCoords))
			if(positionIndexedChildren.has(neighbor)):
				if(cell.CanConnectTo(neighborDirection, GetChildByCoords(neighbor))):
					able = true
	return able


func _draw():
	for item : Cell in positionIndexedChildren.values():
		item.queue_redraw()
