extends TileMapLayer
class_name ShipRoom

@onready var sprite: Sprite2D = $Sprite2D
var positionIndexedChildren : Dictionary[Vector2i, Cell]
var dragNDrop : bool = true

func _ready():
	Setup.call_deferred()
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
		
		
		if(child is ConnectionCell):
			var theChild :ConnectionCell = child as ConnectionCell
			child.grabArea.monitorable = true
			theChild.DoDebugSprites()
	for conCell : ConnectionCell in conCells:
		conCell.RecalculateConnections()
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
