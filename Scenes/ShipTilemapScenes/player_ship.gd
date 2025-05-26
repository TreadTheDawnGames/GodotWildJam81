extends ShipRoom
class_name PlayerShip

static var grabbedRoom : ShipRoom = null

var SubMaps : Array[ShipRoom] = []
var editing = false

@export var gameArea : Vector2
@export var MaxHitpoints : int = 7
@export var gameAreaOffset : Vector2
@onready var capn_hal: Crewmate = $CapnHal

func _ready() -> void:
	hitpoints = MaxHitpoints
	dragNDrop = false
	Faction = ShipFaction.Player
	Setup.call_deferred()
	GlobalPlayerInfo.SetPlayerShip(self)
	capn_hal.hide()
	capn_hal.processStates = false

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
	return get_children().filter(func(c): return c is Crewmate and c.processStates).size()

func GetCrew() -> Array:
	return get_children().filter(func(c): return c is Crewmate and c.processStates)

func GetSpeed() -> int:
	var engineCount : int = 0
	for cell : ConnectionCell in positionIndexedChildren.values().filter(func(a): return is_instance_valid(a) and a is ConnectionCell):
		if(!HasCell(cell.myCoords + cell.Vector2iFromDirection(ConnectionCell.Direction.West))):
			engineCount +=1
	
	if(GlobalPlayerInfo.ActiveLevelInfo):
		if(GlobalPlayerInfo.ActiveLevelInfo.Nebula):
			@warning_ignore("narrowing_conversion")
			engineCount *= 0.5
	
	return engineCount

func EnterStorage():
	global_position = Vector2(9999, 9999)
	process_mode = Node.PROCESS_MODE_DISABLED
	return

var savedPos
func _process(delta: float) -> void:
	if(editing):
		return
	var moveDir = Vector2(Input.get_axis("shipLEFT", "shipRIGHT"), Input.get_axis("shipUP", "shipDOWN")).normalized() * 50 * delta * GetSpeed()
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

func DamageRoom(amount : int, _checkParent : bool = false) -> bool:
	GlobalPlayerInfo.Shake()
	$CrashIntoAsteroid.play()
	hitpoints -= amount
	var thing : float = 1*(clamp(float(hitpoints), 0.1, maxHitpoints)/maxHitpoints)
	sprite.modulate = Color(1,thing, thing , 1)

	if(hitpoints <=0):
		GlobalPlayerInfo.EndGame(false)
		EnterStorage()
		hitpoints = MaxHitpoints
		return true
	return false

func CheckRooms():
	for room in SubMaps:
		if(is_instance_valid(room)):
			print("room position: ", room.positionIndexedChildren.keys()[0])
			print(room, " con cells: ", room.positionIndexedChildren.values().filter(func(a): return a is ConnectionCell)[0].myCoords)
			print("Room: ", room, ", HAL: ", capn_hal._pathfinding(positionIndexedChildren.keys()[0], room.positionIndexedChildren.values().filter(func(a): return a is ConnectionCell)[0].myCoords))#,capn_hal._pathfinding(positionIndexedChildren.keys()[0], room.positionIndexedChildren.values().filter(func(a): a is ConnectionCell)[0].myCoords))
			#if the pathfinder can't find a path, delete the room
			if(capn_hal._pathfinding(positionIndexedChildren.keys()[0], room.positionIndexedChildren.values().filter(func(a): return a is ConnectionCell)[0].myCoords).size() == 0):
				room.DamageRoom(room.hitpoints+1, true)
				for crew :Crewmate in GetCrew():
					if(!positionIndexedChildren.has(local_to_map(crew.position))):
						print("Man overboard!")
						crew.queue_free()
						
						GlobalPlayerInfo.Shake()
						pass
	print("CrewSize: ",GetCrew().size())
	
	if(GetCrew().filter(func(a): return !a.is_queued_for_deletion()).size() <=0):
		GlobalPlayerInfo.EndGame(false)
		pass
	return
