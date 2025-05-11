class_name ShipRoomData
extends TDCardData

var connections : Array[TDCardPlayArea]

func _to_string() -> String:
	var other = "null"
	return "Name: " + CardName + " | Value: " + other

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
				card.scale = card.scale.lerp(Vector2(1.33,1.33), 0.25)
			else:
				card.scale = card.scale.lerp(Vector2(1.5, 1.5), 0.25) 
		else:
			card.scale = card.scale.lerp(Vector2(1.25,1.25), 0.25)
	else:
		card.scale = card.scale.lerp(Vector2.ONE, 0.25)
	return

## Called every frame while the cursor is hovered over the associated TDCard.
func WhileHovered(_card : TDCard):
	if(Input.is_action_just_pressed("rotate")):
		#_card.position -= _card.get_local_mouse_position()
		_card.rotate(deg_to_rad(90))
		_card.Rotate()

	
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: WhileHovered has not been implemented. card: " + CardName)
	return

func HoverEnterAction(_card : TDCard) -> void:
	print("hovered")
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: HoverEnterAction has not been implemented. card: " + card.CardName)
	return

func GrabAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it:  GrabAction has not been implemented. card: " + card.CardName)
	return

func EnterUsable(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	#_card.usable = _playArea.ValidPlayType(PlayType)
	#_card.rotation = _playArea.rotation
	#_card.Rotate()
	return

func Preplay(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func PlayCard(_playArea : TDCardPlayArea, card : TDCard) -> void:
	for enginePart in connections:
		enginePart.monitorable = true
		enginePart.monitoring = true
		
	card.UpdateWhichWall(_playArea.global_position)
	
	card.FillMarker(_playArea.ConnectionSlot)
	print("Played")
	_playArea.hide()
	card.DoGoToPositionMarker = true
	card.SetUsable(false)
	card.z_index = _playArea.z_index+1
	card.reparent(_playArea.get_parent())
	
	return

func Postplay(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func ExitUsable(_card : TDCard) -> void:
	return

func DropAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: DropAction has not been implemented. card: " + card.CardName)
	return

func HoverExitAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: HoverExitAction has not been implemented. card: " + card.CardName)
	return
