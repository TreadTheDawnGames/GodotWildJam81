extends ShipRoom
class_name PlayerShip

static var grabbedRoom : ShipRoom = null

var SubMaps : Array[ShipRoom] = []

func _ready() -> void:
	dragNDrop = false
	Faction = ShipFaction.Player
	Setup.call_deferred()
	GlobalPlayerInfo.SetPlayerShip(self)

func DoCombine(roomToAdd : ShipRoom):
	roomToAdd.Faction = Faction
	roomToAdd.AddToMap(self)
	SubMaps.append(roomToAdd)
	print("Rooms count: ", SubMaps.size())
	pass

func AbleToConnectPiece(roomToAdd : ShipRoom, roomPosition : Vector2i) -> bool:
	var able : bool = false
	for cell : ConnectionCell in roomToAdd.positionIndexedChildren.values().filter(func(a): return a is ConnectionCell):
		var cellCoords : Vector2i = cell.myCoords + roomPosition
		if(HasCell(cellCoords)):
			print("Overlapping Cell")
			return false
		for neighbor in get_surrounding_cells(cellCoords):
			var neighborDirection : ConnectionCell.Direction = ConnectionCell.Direction.get(ConnectionCell.DirectionStringFromVec2i(neighbor-cellCoords))
			if(positionIndexedChildren.has(neighbor)):
				if(cell.CanConnectTo(neighborDirection, GetChildByCoords(neighbor))):
					able = true
	
	return able

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

func _process(delta: float) -> void:
	var moveDir = Vector2(Input.get_axis("shipLEFT", "shipRIGHT"), Input.get_axis("shipUP", "shipDOWN")).normalized() * GetSpeed() * 50 * delta
	global_position += moveDir
	return
	
	
