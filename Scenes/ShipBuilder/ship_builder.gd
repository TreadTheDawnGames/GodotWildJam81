extends TDCardBoard
@export var playerShip : PackedScene

@export var shipRooms : Array[PackedScene]

func _ready():
	for slot : ShopSlot in get_children().filter(func(a): return a is ShopSlot):
		var part = load("res://Scenes/ShipRooms/small_room.tscn").instantiate() as ShipPart
		AddCard(part)
		slot.AssignPart(part)
		part.DoGoToPositionMarker = true
		part.returnSpeed = 5
		part.returnAccuracy = 0.001
	
