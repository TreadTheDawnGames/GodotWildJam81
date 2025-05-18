extends TileMapLayer
class_name ShipRoom

@onready var sprite: Sprite2D = $Sprite2D
var positionIndexedChildren : Dictionary[Vector2i, Cell]
var dragNDrop : bool = true
var LocationMarker : Marker2D = null
var returnToHome : bool = false
var goToOffset : Vector2
var returnSpeed : float = 5
var _grabbedOffset : Vector2
var globalMouse : Vector2
var grabbed : bool

var isSetup : bool = false
var LaserCount : int = 0
enum ShipFaction {Player, Enemy}
var Faction : ShipFaction

@export var maxHitpoints : int = 5
var hitpoints : int = 5

@export var Price : int = 0

var includedCrew : Crewmate

func _ready():
	
	Price = randi_range(10, 30)
	if(includedCrew):
		Price += 20
	var numOfLasers = positionIndexedChildren.values().filter(func(a): return a is LaserCell).size()
	if(numOfLasers > 0):
		Price += 10 * numOfLasers #positionIndexedChildren.values().filter(func(a): return a is LaserCell).size()
	
	Setup.call_deferred()
	returnToHome = true
	sprite = get_node("Sprite2D")
	goToOffset = -sprite.texture.get_size()/2

func Setup():
	if(isSetup):
		return
	modulate = Color.WHITE
	if(includedCrew):
		add_child(includedCrew)
		includedCrew.hide()
		modulate = Color.GOLD

	hitpoints = maxHitpoints
	sprite = get_node("Sprite2D")
	var cells = get_children().filter(func(a): return a is Cell)
	for child : Cell in cells:
		var childCoord: Vector2i = local_to_map(child.position)
		positionIndexedChildren[childCoord] = child
	for cell : Cell in positionIndexedChildren.values():
		cell.AssignLoadOrder()
	var sortedChildren = positionIndexedChildren.values()
	sortedChildren.sort_custom(func(a,b): return a.loadOrder < b.loadOrder)
	for child : Cell in sortedChildren:
		child.Init()
	isSetup = true

func CalculatePivot() -> Vector2:
	var maxX : float = 1
	var maxY : float = 1
	for cell in positionIndexedChildren.keys():
		if(cell.x + 1 > maxX):
			maxX = cell.x +1
		if(cell.y + 1 > maxY):
			maxY = cell.y+1
		if(GetChildByCoords(cell) is ConnectionCell and (cell.sign().x==-1 or cell.sign().y==-1)):
			printerr(name, " Has negative connection cells. Please use only positive ones.")
	
	return Vector2(maxX/2.0, maxY/2.0)

func AddToMap(map : ShipRoom):
	
	ChildStuff(map)
	grabbed = false
	returnToHome = false
	modulate = Color.WHITE
	reparent(map, true)
	var parent = get_parent()
	parent.move_child(self, 0)
	for cell in get_used_cells():
		set_cell(cell, -1)
		#if(child is Sprite2D):
			#continue
	if(includedCrew):
		includedCrew.reparent(map)
		match(map.Faction):
			ShipRoom.ShipFaction.Player:
				includedCrew.alliance = Crewmate.Alliance.ALLIANCE_PLAYER
			ShipRoom.ShipFaction.Enemy:
				includedCrew.alliance = Crewmate.Alliance.ALLIANCE_ENEMY
		includedCrew.processStates = true
		includedCrew.owner = map
		includedCrew.position = Vector2(48,16)
		includedCrew._ready()
		includedCrew.show()
		modulate = Color.WHITE
	
	#queue_free()
	return
	
func ChildStuff(map):
	var conCells : Array[ConnectionCell]
	
	var previousChildrenIndexes : Array[Vector2i] = positionIndexedChildren.keys()
	
	for child : Cell in positionIndexedChildren.values():
		if(child is ConnectionCell):
			conCells.append(child)
			child.grabArea.monitorable = false
		#if(includedCrew):
		#modulate = Color.GOLD
	#
		child.reparent(map, true)
		child.Map = map
		#sprite.reparent(map, true)
		#sprite.get_parent().move_child(sprite, 0)
		SetChildByCoords(child, map.local_to_map(map.to_local(child.global_position)))
		map.SetChildByCoords(child, map.local_to_map(map.to_local(child.global_position)))
		child.reparent.call_deferred(self, true)
		child.ConnectedToShipFunc.call_deferred()
		
	for prevIndex in previousChildrenIndexes:
		positionIndexedChildren.erase(prevIndex)
	
	for conCell : ConnectionCell in conCells:
		conCell.RecalculateConnections()
		conCell.grabArea.monitorable = true

func HasCell(pos : Vector2i) -> bool:
	return positionIndexedChildren.has(pos)

func SetChildByCoords(child : Cell, pos : Vector2i):
	if(child == null):
		positionIndexedChildren.erase(pos)
		return
	positionIndexedChildren.set(pos, child)
	child.myCoords = pos
	return

func GetChildByCoords(pos : Vector2i) -> Cell:
	var cell = positionIndexedChildren.get(pos)
	if(is_instance_valid(cell)):
		return positionIndexedChildren.get(pos)
	else:
		positionIndexedChildren.erase(pos)
		return null
func RemoveChildByCoords(pos:Vector2i):
	positionIndexedChildren.erase(pos)
	return
	
func Ungrab():
	for cell :  ConnectionCell in positionIndexedChildren.values().filter(func(a): return a is ConnectionCell):
		cell.Map.grabbed = false
		cell.hovered = false

func _process(delta: float) -> void:
	globalMouse = get_global_mouse_position()

	
	if(grabbed):
		global_position = globalMouse + _grabbedOffset
	elif returnToHome:
		Return(delta)
	return

func Return(delta):
	if(LocationMarker):
		if(int((global_position - goToOffset).distance_to(LocationMarker.global_position) * 100) > 2):
			global_position = global_position.lerp(LocationMarker.global_position + goToOffset, returnSpeed * delta)
		elif(Vector2i(global_position) != Vector2i(LocationMarker.global_position+ goToOffset)):
			global_position = LocationMarker.global_position + goToOffset

func GetCellWithValidOpeningInDirection(dir : ConnectionCell.Direction):
	for cell : ConnectionCell in positionIndexedChildren.values().filter(func(a): return a is ConnectionCell and a.validConnections.has(dir)):
		if(!cell.GetNeighborInDirection(dir)):
			return cell
	return null

func DamageRoom(amount : int, checkParent : bool = false) -> bool:
	hitpoints -= amount
	var thing : float = 1*(clamp(float(hitpoints), 0.1, maxHitpoints)/maxHitpoints)
	sprite.modulate = Color(1,thing, thing , 1)
	
	if(get_parent() is not PirateShip):
		GlobalPlayerInfo.Shake()
		$CrashIntoAsteroid.play()
	if(hitpoints <=0):
		for cell : Cell in positionIndexedChildren.values():
			cell.Map.positionIndexedChildren.erase(cell.myCoords)
			cell.queue_free()
		if(get_parent() is PlayerShip and get_parent() is not PirateShip and !checkParent):
			get_parent().CheckRooms()
		queue_free()
		return true
	return false
