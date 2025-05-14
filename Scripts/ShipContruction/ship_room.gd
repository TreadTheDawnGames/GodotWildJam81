extends TileMapLayer
class_name ShipRoom

var positionIndexedChildren : Dictionary[Vector2i, Cell]
var dragNDrop : bool = true

func _ready():
	Setup.call_deferred()
func Setup():
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
		

func GetChildByCoords(pos : Vector2i) -> Cell:
	return positionIndexedChildren.get(pos)

func RemoveChildByCoords(pos:Vector2i):
	positionIndexedChildren.erase(pos)
	return
