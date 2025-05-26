extends Node2D
class_name ShipBuilder

@onready var BuildArea: Area2D
@onready var ShopPanel: Sprite2D
@onready var help_button: Button = $HelpButton

var playerShip : PlayerShip
var addingRoom : ShipRoom
var addingRoomCell : ConnectionCell

signal ShopClosed
@onready var tutorial: Control = $HelpButton/ShipyardTutorial

func _ready() -> void:
	playerShip = GlobalPlayerInfo.ShipExitStorage(get_node("ShipPositioner").global_position)
	#playerShip.ClearInvalidValues()
	playerShip.editing = true
	ShopPanel = get_node("ShopPanel")
	BuildArea = get_node("Area2D")
	BuildArea.area_entered.connect(SnapToPlayerShip)
	BuildArea.area_exited.connect(ReturnToShop)
	help_button.pressed.connect(func(): tutorial.show())
	get_node("CloseButton").pressed.connect(CloseShipyard)
	
func SnapToPlayerShip(otherArea : Area2D):
	if(!addingRoom and otherArea.owner is ConnectionCell and otherArea.owner.Map!=playerShip):
		addingRoom = otherArea.owner.Map
		addingRoomCell = otherArea.owner
		$PlaceShipPart.play()
		#addingRoom.reparent.call_deferred(playerShip)
	return

func ReturnToShop(otherArea : Area2D):
	if(addingRoom and otherArea.owner is ConnectionCell and addingRoom == otherArea.owner.Map and otherArea.owner.Map!=playerShip):
		#addingRoom.reparent.call_deferred(ShopPanel)
		if(!Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			addingRoom.Ungrab()
		if(addingRoom.includedCrew):
			addingRoom.modulate = Color.GOLD
		else:
			addingRoom.modulate = Color.WHITE
		addingRoom = null
	return
	
func _process(_delta: float) -> void:
	var addingLocation = playerShip.local_to_map(playerShip.to_local(addingRoom.global_position if addingRoom else Vector2.ZERO).snapped(Vector2(32,32)))
	if(addingRoom and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		#After.call_deferred()
		if(playerShip.AbleToConnectPiece(addingRoom, addingLocation)):
			if(!GlobalPlayerInfo.CanRemoveMoney(addingRoom.Price)):
				addingRoom.modulate = Color.YELLOW
			else:
				addingRoom.modulate = Color.GREEN
			SnapToShipGrid.call_deferred()
		else:
			addingRoom.modulate = Color.RED
	#if there is a room to add
	elif(addingRoom):
		if(playerShip.AbleToConnectPiece(addingRoom, addingLocation) and GlobalPlayerInfo.CanRemoveMoney(addingRoom.Price)):
			GlobalPlayerInfo.RemoveMoney(addingRoom.Price)
			playerShip.DoCombine(addingRoom)
			addingRoomCell = null
			addingRoom = null
		else:
			if(addingRoom.includedCrew):
				addingRoom.modulate = Color.GOLD
			else:
				addingRoom.modulate = Color.WHITE
			addingRoom.Ungrab()
			addingRoom = null

func SnapToShipGrid():
	addingRoom.global_position = playerShip.to_global(playerShip.to_local(addingRoom.global_position).snapped(Vector2(32,32)))


func CloseShipyard():
	playerShip.EnterStorage()
	playerShip.editing = false
	ShopClosed.emit()
	queue_free()
