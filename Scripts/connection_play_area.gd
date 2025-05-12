extends TDCardPlayArea
class_name ConnectionPlayArea

@onready var ConnectionSlot = $TDCardPositionMarker2D
enum WallDirection {none, north = -2, south = 2, east = -1, west = 1}
var cardinalWall : int
@export var manualWall : WallDirection
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	ConnectionSlot = get_node("TDCardPositionMarker2D")
	if(manualWall != WallDirection.none):
		SetCardinalWall(manualWall)
	return
	
func SetCardinalWall(direction : WallDirection):
	match(direction):
		WallDirection.north:
			cardinalWall = -2
		WallDirection.south:
			cardinalWall = 2
		WallDirection.east:
			cardinalWall = -1
		WallDirection.west:
			cardinalWall = 1
	return
	
func SetNextCardinalWall():
	match(cardinalWall):
		-2: #North
			SetCardinalWall(WallDirection.east)
		-1: #East
			SetCardinalWall(WallDirection.south)
		2: #South
			SetCardinalWall(WallDirection.west)
		1: #West
			SetCardinalWall(WallDirection.north)

func ValidConnection():
	sprite.scale = Vector2(1.25,1.25) #.blend(Color.BLACK)
	return

func ValidConnectionOff():
	#sprite.modulate.blend(Color.WHITE)
	sprite.scale = Vector2.ONE #.blend(Color.BLACK)
	return
