class_name ShipRoomData
extends TDCardData

var connections : Array[TDCardPlayArea]
var hasValidWall : bool = false
var connectedToShip : bool = false

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

func GetAreaToSnapTo(card : ShipPart) -> Array:
	var myAreas : Array[ConnectionPlayArea] = []
	var overlappingAreas : Array = []
	var lowDist : int = 2147483647
	print("-----")
	for connection : ConnectionMarker2D in card.Connections:
		var area : ConnectionPlayArea = connection.get_children()[0]
		myAreas.append(area)
		for overlapper : ConnectionPlayArea in area.get_overlapping_areas().filter(func(a): return a is ConnectionPlayArea):
			if(!(area.cardinalWall + overlapper.cardinalWall == 0)):
				return []
			
			overlapper.ValidConnectionOff()
			var overlapperRect = overlapper.collisionShape.shape.get_rect()
			var areaRect = area.collisionShape.shape.get_rect()
			overlapperRect.position = overlapper.to_global(overlapperRect.position)
			areaRect.position = area.to_global(areaRect.position)
			var distToOverlapper = int(area.global_position.distance_to(overlapper.global_position) * 100) #intersectRect.get_area() #int(abs(( thisPoint.x - thatPoint.x) * (thisPoint.y-thatPoint.y))*100)
			if(lowDist > distToOverlapper):
				lowDist = distToOverlapper
			overlappingAreas.append([distToOverlapper, overlapper])
	print("overlappingAreas: ", overlappingAreas)
	var wantedAreaSets = overlappingAreas.filter(func(a): return a[0] == lowDist)
	print("wantedAreaSets: ",wantedAreaSets)
	var wantedAreas : Array[ConnectionPlayArea] = []
	for wantedArea in wantedAreaSets:
		wantedAreas.append(wantedArea[1])
		print(wantedArea[1].get_parent())
	print("wantedAreas: ", wantedAreas)
	var finalArea : Node2D = null
	var leftmostPosition : float = INF
	for potentialLast in wantedAreas:
		if(potentialLast.global_position.x < leftmostPosition):
			finalArea = potentialLast
			leftmostPosition = potentialLast.global_position.x
			
	var myArea : Node2D = null
	if(finalArea):
		var lowDistance : int = 2147483647
		for area in myAreas:
			if(area.global_position.distance_to(finalArea.global_position)<lowDistance):
				lowDistance = area.global_position.distance_to(finalArea.global_position)
				myArea = area
	else:
		return []
	
	return [myArea, finalArea]

func WhileGrabbed(_card : TDCard) -> void:
	var card : ShipPart = _card as ShipPart
	for connection in card.Connections:
		connection.get_children()[0].ValidConnectionOff()
	
	var connection = GetAreaToSnapTo(_card)
	if(connection):
		for con in connection:
			con.ValidConnection()
		
		#var cardConnections = card.Connections.filter(func(a): return a.get_children()[0].cardinalWall == -connection.cardinalWall)
		#cardConnections.sort_custom(func(a: ConnectionPlayArea, b: ConnectionPlayArea): return a.global_position.x < b.global_position.x)
		#if(cardConnections.size()>0):
			#var cardConnection : ConnectionPlayArea = cardConnections[0].get_children()[0]
			#cardConnection.ValidConnection()
	
	
	
	#
	##var validChildren : Array[ConnectionPlayArea] = []
	#for connection : ConnectionMarker2D in card.Connections:
		#
		#var doorOrEngine :  ConnectionPlayArea = connection.get_children().filter(func(a): return a is ConnectionPlayArea)[0]
		#var overlappingAreas = doorOrEngine.get_overlapping_areas().filter(func(a): return a is ConnectionPlayArea)
		#if(overlappingAreas.size()>0):
			#for area in overlappingAreas:
				#if(doorOrEngine.cardinalWall + area.cardinalWall == 0):
					#print(overlappingAreas)
					#doorOrEngine.ValidConnection()
					#card.UpdateWhichWall(doorOrEngine.global_position)
			#
		#else:
			#doorOrEngine.ValidConnectionOff()
#
				##validChildren.append(child)
			#pass
		
		
	#
	#var nearestValid : ConnectionPlayArea
	#var distToNearest : float = INF
	#if(validChildren.size()>0):
		#hasValidWall = true
		#for valid in validChildren:
			#valid.ValidConnectionOff()
			#var dist = valid.global_position.distance_to(playArea.global_position)
			#if(dist < distToNearest):
				#nearestValid = valid
				#distToNearest = dist
		#nearestValid.ValidConnection()
		#playArea.ValidConnection()
	#if(nearestValid):
		#card.UpdateWhichWall(nearestValid.global_position)
	#card.usable = hasValidWall
	
	return
func WhileUsable(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func EnterUsable(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func Preplay(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func PlayCard(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	
	
	return

func Postplay(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	UndoVisualConnectableness(_playArea, _card)
	return

func ExitUsable(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	UndoVisualConnectableness(_playArea, _card)
	return

func DropAction(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	#var card = _card as ShipPart
	#for enginePart in connections:
		#enginePart.monitorable = true
		#enginePart.monitoring = true
	#
	#for connection : ConnectionMarker2D in card.Connections:
		#var connectionArea :  ConnectionPlayArea = connection.get_children().filter(func(a): return a is ConnectionPlayArea)[0]
		#var overlappingAreas = connectionArea.get_overlapping_areas().filter(func(a): return a is ConnectionPlayArea)
		#if(overlappingAreas.size()>0):
			#connectionArea.monitorable = false
			#connectionArea.monitoring = false
			#
				#
			#for area in overlappingAreas:
				#card.FillMarker(area.ConnectionSlot)
				##area.hide()
				#card.z_index = area.z_index+1
				#card.reparent(area.get_parent())
			#
			#print("Played")
			#card.DoGoToPositionMarker = true
			#card.SetUsable(false)
			#card.grabbed = false
			#card.Unhovered()
	#
	#UndoVisualConnectableness(_playArea, card)
		
		#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: DropAction has not been implemented. card: " + card.CardName)
	return
	
func UndoVisualConnectableness(_playArea : TDCardPlayArea, _card : TDCard):
	for connection : ConnectionMarker2D in _card.Connections:
		for child in connection.get_children().filter(func(a): return a is ConnectionPlayArea):
			child.ValidConnectionOff()
	if(_playArea):
		_playArea.ValidConnectionOff()
	
func HoverExitAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: HoverExitAction has not been implemented. card: " + card.CardName)
	return
