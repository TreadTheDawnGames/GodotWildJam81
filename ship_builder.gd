extends Node2D
@onready var BuildArea: Area2D = $Area2D
@onready var ShopPanel: Sprite2D = $ShopPanel

var playerShip : PlayerShip
var addingRoom : ShipRoom
var addingRoomCell : ConnectionCell

func _ready() -> void:
	playerShip = get_node("PlayerShip")
	ShopPanel = get_node("ShopPanel")
	BuildArea.area_entered.connect(SnapToPlayerShip)
	BuildArea.area_exited.connect(ReturnToShop)
	
	
func SnapToPlayerShip(otherArea : Area2D):
	if(!addingRoom and otherArea.owner is ConnectionCell and otherArea.owner.Map!=playerShip):
		addingRoom = otherArea.owner.Map
		addingRoomCell = otherArea.owner
		print("Entered")
		#addingRoom.reparent.call_deferred(playerShip)
	return

func ReturnToShop(otherArea : Area2D):
	if(addingRoom and otherArea.owner is ConnectionCell and addingRoom == otherArea.owner.Map and otherArea.owner.Map!=playerShip):
		print("Exited")
		#addingRoom.reparent.call_deferred(ShopPanel)
		addingRoom.global_position.x = 400
		addingRoom.modulate = Color.WHITE
		addingRoom = null
	return
	
func _process(_delta: float) -> void:
	var addingLocation = playerShip.local_to_map(playerShip.to_local(addingRoom.global_position if addingRoom else Vector2.ZERO).snapped(Vector2(32,32)))
	if(addingRoom and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		After.call_deferred()
		if(playerShip.AbleToConnectPiece(addingRoom, addingLocation)):
			addingRoom.modulate = Color.GREEN
		else:
			addingRoom.modulate = Color.RED
			
	elif(addingRoom):
		if(playerShip.AbleToConnectPiece(addingRoom, addingLocation)):
			playerShip.DoCombine(addingRoom)
			addingRoomCell = null
			addingRoom = null
		else:
			addingRoom.global_position.x = 400
			addingRoomCell.Unhovered()
			addingRoom.modulate = Color.WHITE
			addingRoom = null

func After():
	addingRoom.global_position = playerShip.to_global(playerShip.to_local(addingRoom.global_position).snapped(Vector2(32,32)))
	
