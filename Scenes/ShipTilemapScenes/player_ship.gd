extends ShipRoom
class_name PlayerShip

static var grabbedRoom : ShipRoom = null

var SubMaps : Array[ShipRoom] = []
var editing = false

@export var gameArea : Vector2

@export var gameAreaOffset : Vector2

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
			if(positionIndexedChildren.has(neighbor) and positionIndexedChildren.get(neighbor) is ConnectionCell):
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
	for cell : ConnectionCell in positionIndexedChildren.values().filter(func(a): return is_instance_valid(a) and a is ConnectionCell):
		if(!HasCell(cell.myCoords + cell.Vector2iFromDirection(ConnectionCell.Direction.West))):
			engineCount +=1
	return engineCount

func EnterStorage():
	global_position = Vector2(9999, 9999)
	process_mode = Node.PROCESS_MODE_DISABLED
	return

func _process(delta: float) -> void:
	if(editing):
		return
	var moveDir = Vector2(Input.get_axis("shipLEFT", "shipRIGHT"), Input.get_axis("shipUP", "shipDOWN")).normalized() * GetSpeed() * 50 * delta
	global_position += moveDir
	
	ClampPosition()
	
	return
	
	
func ClampPosition():
	var stuff : Array = positionIndexedChildren.keys()
	stuff.sort_custom(func(a,b): return a.x > b.x)
	var maxX : float = stuff[0].x
	stuff.sort_custom(func(a,b): return a.y > b.y)
	var maxY : float = stuff[0].y
	stuff.sort_custom(func(a,b): return a.x < b.x)
	var minX : float = stuff[0].x
	stuff.sort_custom(func(a,b): return a.y < b.y)
	var minY : float = stuff[0].y
	var shipSizeMax : Vector2 = Vector2((maxX+1) *32,(maxY+1) *32)
	var shipSizeMin : Vector2 = Vector2(minX*32, minY*32)
	global_position = global_position.clamp(Vector2.ZERO - shipSizeMin + gameAreaOffset, gameArea - shipSizeMax + gameAreaOffset)
	return
#func ClearInvalidValues():
	#var invalid : Array = []
	#for cell in positionIndexedChildren.values().filter(func(a): return !is_instance_valid(a)):
		#invalid.append(positionIndexedChildren.find_key(cell))
	#for invalidCell in invalid:
		#positionIndexedChildren.erase(invalidCell)

func DamageRoom(_amount : int) -> bool:
	#hitpoints -= amount
	#if(hitpoints <=0):
		#for cell : Cell in positionIndexedChildren.values():
			#cell.Map.positionIndexedChildren.erase(cell.myCoords)
			#cell.queue_free()
		#if(get_parent() is PlayerShip):
			#get_parent().ClearInvalidValues()
		#queue_free()
		#return true
	return false
