extends Cell
class_name ConnectionCell

enum Direction {North, South, East, West}
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
	print("myCoords: ", myCoords)

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
			print("Map does not have: ", cell, " (",DirectionString(cell-myCoords),")")
			continue
		match(cell - myCoords):
			Vector2i.LEFT:
				AddConnection(Direction.West)
				print("SurroundingAdd: West")
			Vector2i.RIGHT:
				AddConnection(Direction.East)
				print("SurroundingAdd: East")
				
			Vector2i.UP:
				AddConnection(Direction.North)
				print("SurroundingAdd: North")
			Vector2i.DOWN:
				AddConnection(Direction.South)
				print("SurroundingAdd: South")
	
	
	return

func IsOnTop() -> bool:
	if(hoveredParts.size() > 0):
		return hoveredParts[-1] == self #().get_nodes_in_group("DraggableHovered"):
	else:
		return false
		

func _process(delta: float) -> void:
	if(!Map.dragNDrop):
		return
	if(hovered and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		var stringCons : Array[String]
		for con in validConnections:
			stringCons.append(Direction.find_key(con))
		print(stringCons)
	
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

func Rotate():
	
	return

func AddRandomConnections():
	var extraDoors : int = 0
	while(extraDoors==0):
		for i in randWeight:
			if(randi() % randWeight == 0):
				print("Random add ", Direction.find_key(i))
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

func DirectionString(dir : Vector2i) -> String:
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
