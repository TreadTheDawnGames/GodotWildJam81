extends Cell
class_name ConnectionCell

enum Direction {North, East, South, West}
@export var validConnections : Array[Direction]
@onready var grabArea: Area2D = $Area2D

var hasMouse : bool = false

const ICON = preload("res://icon.svg")
const ENGINE = preload("res://Assets/Sprites/ConnectionSprites/engine.png")
const HATCH = preload("res://Assets/Sprites/ConnectionSprites/hatch.png")
const DOOR = preload("res://Assets/Sprites/ConnectionSprites/door.png")

@export var isDebug : bool = true
@export var randWeight : int = 4
static var hoveredParts : Array[ConnectionCell]
var hovered : bool = false
@onready var debugSpritesParent : Node2D = $DebugSprites


func AssignLoadOrder():
	loadOrder = 0

func Init():
	super.Init()
	grabArea = get_node("Area2D")
	debugSpritesParent = get_node("DebugSprites")
	AddRandomConnections()
	AddSurroundingTiles()
	if(!grabArea.mouse_entered.is_connected(Hovered)):
		grabArea.mouse_entered.connect(Hovered)
	if(!grabArea.mouse_exited.is_connected(Unhovered)):
		grabArea.mouse_exited.connect(Unhovered)
	DoDebugSprites()
	


func DoDebugSprites(recurse : bool = false):
	if(!isDebug):
		return

	for sprite : Sprite2D in debugSpritesParent.get_children():
		sprite.queue_free()
		
	for con in validConnections:
		var sprite = Sprite2D.new()
		sprite.name += "DEBUG"
		var pos : Vector2 = Vector2.ZERO
		var addY:int = 0
		var addX:int = 0
		sprite.texture = ICON
		sprite.scale *= 0.1
		var neighborCell = GetNeighborInDirection(con)
		#if(!neighborCell or neighborCell is not ConnectionCell):
		match(con):
			Direction.North:
				#sprite.texture = HATCH
				pos = Vector2.UP
				addY=3
				sprite.modulate = Color.RED
			Direction.South:
				#sprite.texture = HATCH
				pos = Vector2.DOWN
				sprite.modulate = Color.GREEN
				addY=-3
			Direction.West:
				#sprite.texture = ENGINE
				sprite.modulate = Color.BLUE
				addX=3
				pos = Vector2.LEFT
			Direction.East:
				#sprite.texture = DOOR
				sprite.modulate = Color.YELLOW
				pos = Vector2.RIGHT
				addX=-3
		sprite.position = (pos * 16) + Vector2(addX, addY)
		if (neighborCell and Map.HasCell(neighborCell.myCoords) and neighborCell is ConnectionCell):
			sprite.modulate.a = 0.25
		
		if(neighborCell and neighborCell is ConnectionCell and !recurse):
			neighborCell.DoDebugSprites(true)
		
		if(sprite.texture):
			debugSpritesParent.add_child(sprite)
		else:
			sprite.queue_free()

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
		

func _process(_delta: float) -> void:
	if(hovered and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		var stringCons : Array[String]
		for con in validConnections:
			stringCons.append(Direction.find_key(con))
	if(!Map):
		return
	if(!Map.dragNDrop):
		return
	
	
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Map.grabbed):
		if(IsOnTop()):
			Map._grabbedOffset = Map.global_position - Map.globalMouse
			Map.grabbed = true
			
	elif(not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Map.grabbed):
		Unhovered()
		Map.grabbed = false
		#_grabbedOffset = Vector2.ZERO
		

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
				AddConnection(i)
			if(DirectionStringFromEnum(i) == "East"):
				if(randi()%weight/2.0 == 0):
					AddConnection(i)
					
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

static func DirectionStringFromEnum(dir : Direction) -> String:
	return Direction.find_key(dir)

static func DirectionStringFromVec2i(dir : Vector2i) -> String:
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
	if(!neighborCell):
		return false
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
