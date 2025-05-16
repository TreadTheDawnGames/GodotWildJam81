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

@export var Price : int = 0

func _ready():
	Setup.call_deferred()
	returnToHome = true
	goToOffset = -sprite.texture.get_size()/2

func Setup():
	sprite = get_node("Sprite2D")
	var cells = get_children().filter(func(a): return a is Cell)
	for child : Cell in cells:
		var childCoord: Vector2i = local_to_map(child.position)
		positionIndexedChildren.set(childCoord, child)
		#print(child)
	for cell : Cell in positionIndexedChildren.values():
		cell.AssignLoadOrder()
	var sortedChildren = positionIndexedChildren.values()
	sortedChildren.sort_custom(func(a,b): return a.loadOrder < b.loadOrder)
	for child : Cell in sortedChildren:
		child.Init()

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
	var conCells : Array[ConnectionCell]
	for child : Cell in positionIndexedChildren.values():
		print(child)
		if(child is ConnectionCell):
			conCells.append(child)
			child.grabArea.monitorable = false
			
		child.Map = map
		child.reparent(map, true)
		sprite.reparent(map, true)
		sprite.get_parent().move_child(sprite, 0)
		map.SetChildByCoords(child, map.local_to_map(map.to_local(child.global_position)))
		
		
	for conCell : ConnectionCell in conCells:
		conCell.RecalculateConnections()
		conCell.grabArea.monitorable = true
		
	queue_free()
	return

func HasCell(pos : Vector2i) -> bool:
	return positionIndexedChildren.has(pos)

func SetChildByCoords(child : Cell, pos : Vector2i):
	positionIndexedChildren.set(pos, child)
	child.myCoords = pos
	return

func GetChildByCoords(pos : Vector2i) -> Cell:
	return positionIndexedChildren.get(pos)

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
			print(Vector2i(global_position),Vector2i(LocationMarker.global_position+ goToOffset))
			global_position = LocationMarker.global_position + goToOffset
