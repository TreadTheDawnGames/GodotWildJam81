class_name ShipRoomData
extends TDCardData

var connections : Array[TDCardPlayArea]
var hasValidWall : bool = false

func _to_string() -> String:
	return "Name: " + CardName + " | Connections: " + str(connections)

func SpecialSetup(_card : TDCard):
	return

func Frame(card : TDCard, _delta : float) -> void:
	if(TDCard.hoveredCards.size() > 0):
		if(TDCard.hoveredCards[-1] != card):
			card._hovered = false
		else:
			card._hovered = true
	
	
	if(card._hovered):
		if(card.grabbed):
			if(not card.usable):
				card.modulate = card.modulate.blend(Color.WHITE) #.lerp(Vector2(1.33,1.33), 0.25)
			#else:
				#card.modulate = card.modulate.blend(Color.GREEN) #.lerp(Vector2(1.33,1.33), 0.25)
				#card.scale = card.scale.lerp(Vector2(1.5, 1.5), 0.25) 
		else:
			card.modulate = card.modulate.blend(Color.YELLOW) #.lerp(Vector2(1.33,1.33), 0.25)
			#card.scale = card.scale.lerp(Vector2(1.25,1.25), 0.25)
	else:
		card.modulate = card.modulate.blend(Color.WHITE) #.lerp(Vector2(1.33,1.33), 0.25)
		#card.scale = card.scale.lerp(Vector2.ONE, 0.25)
	return

## Called every frame while the cursor is hovered over the associated TDCard.
func WhileHovered(_card : TDCard):
	if(Input.is_action_just_pressed("rotate")):
		#_card.position -= _card.get_local_mouse_position()
		_card.Rotate()

	
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: WhileHovered has not been implemented. card: " + CardName)
	return

func HoverEnterAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: HoverEnterAction has not been implemented. card: " + card.CardName)
	return

func GrabAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it:  GrabAction has not been implemented. card: " + card.CardName)
	return

func WhileUsable(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	var playArea = _playArea as ConnectionPlayArea
	var card : ShipPart = _card as ShipPart
	
	var validChildren : Array[ConnectionPlayArea] = []
	for connection : ConnectionMarker2D in card.Connections:
		var child : ConnectionPlayArea = connection.get_children()[0]
		if(child.cardinalWall + playArea.cardinalWall == 0):
			validChildren.append(child)
	
	var nearestValid : ConnectionPlayArea
	var distToNearest : float = INF
	if(validChildren.size()>0):
		hasValidWall = true
		for valid in validChildren:
			valid.ValidConnectionOff()
			var dist = valid.global_position.distance_to(playArea.global_position)
			if(dist < distToNearest):
				nearestValid = valid
				distToNearest = dist
		nearestValid.ValidConnection()
		playArea.ValidConnection()
	if(nearestValid):
		card.UpdateWhichWall(nearestValid.global_position)
	card.usable = hasValidWall
	
	return

func EnterUsable(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func Preplay(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func PlayCard(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	for enginePart in connections:
		enginePart.monitorable = true
		enginePart.monitoring = true
		
	var card : ShipPart = _card as ShipPart
	
	card.FillMarker(_playArea.ConnectionSlot)
	print("Played")
	_playArea.hide()
	card.DoGoToPositionMarker = true
	card.SetUsable(false)
	card.z_index = _playArea.z_index+1
	card.reparent(_playArea.get_parent())
	card.grabbed = false
	card.Unhovered()
	return

func Postplay(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	DropAction(_playArea, _card)
	return

func ExitUsable(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	DropAction(_playArea, _card)
	return

func DropAction(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	for connection : ConnectionMarker2D in _card.Connections:
		for child in connection.get_children().filter(func(a): return a is ConnectionPlayArea):
			child.ValidConnectionOff()
	if(_playArea):
		_playArea.ValidConnectionOff()
	
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: DropAction has not been implemented. card: " + card.CardName)
	return

func HoverExitAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: HoverExitAction has not been implemented. card: " + card.CardName)
	return
