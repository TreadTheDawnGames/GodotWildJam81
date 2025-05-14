extends Cell
class_name ConnectionCell

enum Direction {North, East, South, West}
var validConnections : Array[Direction]
@onready var grabArea: Area2D = $Area2D

var hasMouse : bool = false


@export var isDebug : bool = true
@export var randWeight : int = 4
static var hoveredParts : Array[ConnectionCell]
var _lastMousePos : Vector2
var grabbed : bool
var _grabbedOffset : Vector2
var LocationMarker : Marker2D = null
var returnToHome : bool = false
var returnSpeed : float = 5
var hovered : bool = false
@onready var debugSpritesParent : Node2D = $DebugSprites

func AssignLoadOrder():
	loadOrder = 0

func Init():
	super.Init()
	debugSpritesParent = get_node("DebugSprites")
	AddRandomConnections()
	AddSurroundingTiles()
	grabArea.mouse_entered.connect(Hovered)
	grabArea.mouse_exited.connect(Unhovered)
	
	DoDebugSprites()

func DoDebugSprites():
	if(!isDebug):
		return

	for sprite : Sprite2D in debugSpritesParent.get_children():
		sprite.queue_free()
		
	for con in validConnections:
		const ICON = preload("res://icon.svg")
		var sprite = Sprite2D.new()
		sprite.texture = ICON
		sprite.scale *= 0.1
		debugSpritesParent.add_child(sprite)
		sprite.name += "DEBUG"
		var pos : Vector2 = Vector2.ZERO
		match(con):
			Direction.North:
				pos = Vector2.UP
			Direction.South:
				pos = Vector2.DOWN
			Direction.West:
				pos = Vector2.LEFT
			Direction.East:
				pos = Vector2.RIGHT
		sprite.position = pos * 16

func AddSurroundingTiles():
	var surroundingCells = GetNeighbors()
	#print(myPos, ": ", surroundingCells)
	for cell in surroundingCells:
		if(!Map.positionIndexedChildren.has(cell)):
			continue
		match(cell - myCoords):
			Vector2i.LEFT:
				AddConnection(Direction.West)
			Vector2i.RIGHT:
				AddConnection(Direction.East)
			Vector2i.UP:
				AddConnection(Direction.North)
			Vector2i.DOWN:
				AddConnection(Direction.South)
	
	
	return

func IsOnTop() -> bool:
	if(hoveredParts.size() > 0):
		return hoveredParts[-1] == self #().get_nodes_in_group("DraggableHovered"):
	else:
		return false
		
func Rotate():
		print("-----")
		var rotatedConnects : Array[Direction] = []
		for validConnection in validConnections:
			var valCon : int = int(validConnection)
			print("Before ", DirectionStringFromEnum(validConnection))
			valCon += 1
			if(valCon == 4):
				valCon = 0
			rotatedConnects.append(valCon as Direction)
			print("after ", DirectionStringFromEnum(valCon as Direction))
		validConnections = rotatedConnects
		#DoDebugSprites()

func _process(delta: float) -> void:
	if(hovered and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		var stringCons : Array[String]
		for con in validConnections:
			stringCons.append(Direction.find_key(con))
		print(stringCons)
	
	if(!Map.dragNDrop):
		return
	
	#if(Input.is_action_just_pressed("rotate") and grabbed):
		#Map.rotate(deg_to_rad(90))
		
		#for child : ConnectionCell in Map.positionIndexedChildren.values().filter(func(a): return a is ConnectionCell):
			#child.Rotate()
		#DoDebugSprites()
		
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not grabbed):
		if(IsOnTop()):
			_grabbedOffset = Map.global_position - get_global_mouse_position()
			grabbed = true
			
	elif(not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and grabbed):
		grabbed = false
	_lastMousePos = get_global_mouse_position()
		
	if(grabbed):
		Map.global_position = get_global_mouse_position() + _grabbedOffset
	elif returnToHome:
		if(LocationMarker):
			if(Map.global_position.distance_to(LocationMarker.global_position) > 0.01):
				Map.global_position = Map.global_position.lerp(LocationMarker.Map.global_position, returnSpeed * delta)
	return
	
func Hovered() -> void:
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		return
	hoveredParts.append(self)
	#add_to_group("DraggableHovered")
	hovered = true
	return

func Unhovered() -> void:
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		return
	#remove_from_group("DraggableHovered")
	hoveredParts.erase(self)
	hovered = false
	return


func AddRandomConnections():
	var extraDoors : int = 0
	while(extraDoors==0):
		for i in 4:
			var weight = randWeight
			if(DirectionStringFromEnum(i) == "West"):
				weight /=2
			if(randi() % weight == 0):
				AddConnection(i)
				extraDoors+=1
	return

func AddConnection(direction : Direction) -> bool:
	if(!validConnections.has(direction)):
		validConnections.append(direction)
		DoDebugSprites()
		return true
	return false

func RemoveConnection(direction : Direction):
	var timesToIterate:int=validConnections.filter(func(a): return a == direction).size()
	for time in timesToIterate:
		validConnections.erase(direction)
		DoDebugSprites()
	return

func DirectionStringFromEnum(dir : Direction) -> String:
	return Direction.find_key(dir)

func DirectionStringFromVec2i(dir : Vector2i) -> String:
	match(dir):
		Vector2i.LEFT:
			return ("West")
		Vector2i.RIGHT:
			return ("East")
		Vector2i.UP:
			return ("North")
		Vector2i.DOWN:
			return ("South")
	return "Error"
	

func CanConnectTo(direction : Direction, neighborCell : ConnectionCell) -> bool:
	var can : bool
	match(direction):
		Direction.East:
			can = neighborCell.validConnections.has(Direction.West) and validConnections.has(Direction.East)
		Direction.West:
			can = neighborCell.validConnections.has(Direction.East) and validConnections.has(Direction.West)
		Direction.South:
			can = neighborCell.validConnections.has(Direction.North) and validConnections.has(Direction.South)
		Direction.North:
			can = neighborCell.validConnections.has(Direction.South) and validConnections.has(Direction.North)
	return can

func SetNewMap(newMap : ShipRoom):
	Map = newMap
	Map.SetChildByCoords(self, Map.local_to_map(position))

func RecalculateConnections():
	var eraseMe : Array[Direction] = []
	for con in 4:
		var neighborInDir : Cell = GetNeighborInDirection(con)
		if(neighborInDir and neighborInDir is ConnectionCell):
			var theNeighbor : ConnectionCell = neighborInDir as ConnectionCell
			if(!CanConnectTo(con, GetNeighborInDirection(con))):
				eraseMe.append(con)
				theNeighbor.validConnections.erase(OppositeDirection(con))
				theNeighbor.DoDebugSprites()
				#theNeighbor.RecalculateConnections()
				pass
	for erase in eraseMe:
		validConnections.erase(erase)
	DoDebugSprites()
	
	return

func OppositeDirection(dir : Direction) -> Direction:
	match(dir):
		Direction.North:
			return Direction.South
		Direction.East:
			return Direction.West
		Direction.South:
			return Direction.North
		Direction.West:
			return Direction.East
		_: 
			printerr("Somehow picking opposite direction is broken")
			return dir


func Vector2iFromDirection(dir : Direction) -> Vector2i:
	match(dir):
		Direction.North:
			return Vector2i.UP
		Direction.East:
			return Vector2i.RIGHT
		Direction.South:
			return Vector2i.DOWN
		Direction.West:
			return Vector2i.LEFT
		_: 
			return Vector2i.ZERO

func GetNeighborInDirection(dir : Direction) -> Cell:
	return Map.GetChildByCoords(myCoords + Vector2iFromDirection(dir))
