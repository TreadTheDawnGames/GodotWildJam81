extends ShipRoom
class_name PlayerShip

static var grabbedRoom : ShipRoom = null

var SubMaps : Array[ShipRoom] = []
var editing = false

@export var gameArea : Vector2
@export var MaxHitpoints : int = 7
@export var gameAreaOffset : Vector2

func _ready() -> void:
	hitpoints = MaxHitpoints
	dragNDrop = false
	Faction = ShipFaction.Player
	Setup.call_deferred()
	GlobalPlayerInfo.SetPlayerShip(self)

func DoCombine(roomToAdd : ShipRoom):
	roomToAdd.Faction = Faction
	roomToAdd.AddToMap(self)
	SubMaps.append(roomToAdd)
	changed.emit()
	pass

func AbleToConnectPiece(roomToAdd : ShipRoom, roomPosition : Vector2i) -> bool:
	var able : bool = false
	for cell : ConnectionCell in roomToAdd.positionIndexedChildren.values().filter(func(a): return a is ConnectionCell):
		var cellCoords : Vector2i = cell.myCoords + roomPosition
		if(HasCell(cellCoords)):
			return false
		for neighbor in get_surrounding_cells(cellCoords):
			var neighborDirection : ConnectionCell.Direction = ConnectionCell.Direction.get(ConnectionCell.DirectionStringFromVec2i(neighbor-cellCoords))
			if(positionIndexedChildren.has(neighbor) and positionIndexedChildren.get(neighbor) is ConnectionCell):
				if(cell.CanConnectTo(neighborDirection, GetChildByCoords(neighbor))):
					able = true
	
	return able

func GetFirepower() -> int:
	var firepower : int = 0
	for room in SubMaps:
		if(is_instance_valid(room)):
			firepower += room.get_children(true).filter(func(a): return a is LaserCell).size()
	return firepower
	
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

var savedPos
func _process(delta: float) -> void:
	if(editing):
		return
	var moveDir = Vector2(Input.get_axis("shipLEFT", "shipRIGHT"), Input.get_axis("shipUP", "shipDOWN")).normalized() * 50 * delta# * GetSpeed()
	global_position += moveDir
	
	ClampPosition()
	
	Engine.time_scale = GetSpeed()/2.0
	if(Input.is_action_pressed("DEBUG-Speed++++")):
		Engine.time_scale = 500
		savedPos = global_position
		global_position = Vector2(9999,9999)
	if(Input.is_action_just_released("DEBUG-Speed++++")):
		global_position = savedPos
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

func DamageRoom(amount : int) -> bool:
	GlobalPlayerInfo.Shake()
	hitpoints -= amount
	
	if(hitpoints <=0):
		GlobalPlayerInfo.ActiveLevel.ExitWithoutShop()
		GlobalPlayerInfo.EndGame(false)
		EnterStorage()
		hitpoints = MaxHitpoints
		return true
	return false

func CheckRooms():
	for room in SubMaps:
		var cpnHal :Crewmate = get_children().filter(func(a): return a is Crewmate)[0]
		print(cpnHal._pathfinding(Vector2(0,0), room.positionIndexedChildren.keys()[0]))
		#check for connection to me
		#if no
			#destroy room
		
		pass
	return
