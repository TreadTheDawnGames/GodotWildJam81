extends ShipRoom
class_name PlayerShip

static var grabbedRoom : ShipRoom = null

func _ready() -> void:
	dragNDrop = false
	#super._ready()
	Setup.call_deferred()
	GlobalPlayerInfo.SetPlayerShip(self)

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


#func _draw():
	#for item : Cell in positionIndexedChildren.values():
		#if(item):
			#item.queue_redraw()

func GetFirepower() -> int:
	#TODO Calculate Firepower based on number of weapon cells
	return 0
	
func GetCrewCount() -> int:
	return get_children().filter(func(c): return c is Crewmate).size()

func GetSpeed() -> int:
	var engineCount : int = 0
	for cell : ConnectionCell in positionIndexedChildren.values().filter(func(a): return a is ConnectionCell):
		if(!HasCell(cell.myCoords + cell.Vector2iFromDirection(ConnectionCell.Direction.West))):
			engineCount +=1
	return engineCount

func EnterStorage():
	global_position = Vector2(9999, 9999)
	process_mode = Node.PROCESS_MODE_DISABLED
	return
