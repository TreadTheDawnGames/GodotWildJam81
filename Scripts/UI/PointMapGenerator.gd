extends Node2D

# Many thanks to this Tut here for helping me figure this out. I only really had to translate some parts from Godot 3.5 to 4.4
# https://www.youtube.com/watch?v=6NL7azkpNN4

# Points here are our PitStops

# These are templates that hold placeholder Marker2Ds for the TextureButtons to be placed in
const pointMaps := [
	preload("res://Scenes/UI/PointMaps/PointMap1.tscn"),
	preload("res://Scenes/UI/PointMaps/PointMap2.tscn"),
	preload("res://Scenes/UI/PointMaps/PointMap3.tscn"),
]
const idealStartPos := Vector2( 0, 300 )
const idealEndPos := Vector2( 1024, 300 )
var marg := 25
var cruiser: Node2D
var lineHighlighter: Line2D
var mapDone := false
var astar := AStar2D.new()
var dictOfPoints: Dictionary = {}
var dictOfIds: Dictionary = {}
var dictOfLevelInfos: Dictionary = {} #uses the points as indices for the levelinfo

func _ready() -> void:
	randomize()
	cruiser = get_parent().get_node("Cruiser")
	cruiser.connect('doneMoving', doneMovingCruiser)
	lineHighlighter = $"../Line2D"
	makeMap()


func makeMap() -> void:
	placePointsFromMap()
	connectPointsOnMap()
	areLeftAndRightConnected()
	placeCruiserOnLeftMostPoint()
	pointsConnectedToCruiserPoint()
	mapDone = true

# hasVisionUpgrade allows popups on connections to possible routes
# however the popups are still recreated, that should be reworked if we manage to work in the upgrade
func pointsConnectedToCruiserPoint(hasVisionUpgrade: bool = false) -> Array:
	var arrOfConnectedPoints: Array
	var pointToGetConnectionsOf: Control = getClosestPointToPosPassedIn( cruiser.global_position )
	var idOfPointToGetConnectionsOf: int = dictOfIds[ pointToGetConnectionsOf ]
	
	var arrOfPointIdThatAreConnectedToTheMainPoint = astar.get_point_connections( idOfPointToGetConnectionsOf )
	for id in arrOfPointIdThatAreConnectedToTheMainPoint:
		var point = dictOfPoints[ id ]
		var pointButton: TextureButton = point.get_node("TextureButton")
		if point.global_position.distance_to(idealStartPos) < pointToGetConnectionsOf.global_position.distance_to(idealStartPos):
			pointButton.disabled
			pointButton.disconnect('mouse_entered', Callable(Popups, "showPitStopPopup"))
			pointButton.disconnect('pressed', pointPressed)
		else:
			point = setPopupsOnButton(id)
			arrOfConnectedPoints.append( point )
			setLineHighlightToSomeLines( arrOfConnectedPoints, pointToGetConnectionsOf.global_position )
			if hasVisionUpgrade:
				var arrayOfConnectionsToConnectedPoint: Array = astar.get_point_connections( id )
				for secondId in arrayOfConnectionsToConnectedPoint:
					var secondPoint = setPopupsOnButton( secondId )
	if arrOfConnectedPoints.size() == 0:
		for id in arrOfPointIdThatAreConnectedToTheMainPoint:
			var point = setPopupsOnButton(id)
			arrOfConnectedPoints.append( point )
			setLineHighlightToSomeLines( arrOfConnectedPoints, pointToGetConnectionsOf.global_position )
			if hasVisionUpgrade:
				var arrayOfConnectionsToConnectedPoint: Array = astar.get_point_connections( id )
				for secondId in arrayOfConnectionsToConnectedPoint:
					var secondPoint = setPopupsOnButton( secondId )
	return arrOfConnectedPoints

func moveCruiserToThisPoint(pos: Vector2) -> void:
	cruiser.moveTo(pos)

func setPopupsOnButton(id: int) -> Control:
	var point = dictOfPoints[ id ]
	var pointButton: TextureButton = point.get_node("TextureButton")
	pointButton.disconnect('mouse_entered', Callable(Popups, "showPitStopPopup"))
	var pointPosition: Vector2 = point.global_position + randAmtToAdd()
	var levelInfo = LevelInfo.generateRandomLevel(false, pointPosition, false, false)
	var popupText = levelInfo.makePopupText(levelInfo.TimeToReach, levelInfo.Reputation, levelInfo.SpaceDust, levelInfo.Pirates, levelInfo.AsteroidDensity)
	dictOfLevelInfos[ point ] = levelInfo

	pointButton.mouse_entered.connect(Callable(Popups, "showPitStopPopup").bind(Rect2i(Vector2i(point.global_position), Vector2i(point.size)), popupText))
	pointButton.mouse_exited.connect(Callable(Popups, "hidePitStopPopup"))
	pointButton.pressed.connect(pointPressed.bind(point))
	return point

func setLineHighlightToSomeLines(arrOfPoses: Array, centerPos: Vector2) -> void:
	lineHighlighter.clear_points()
	var ind: int = 0
	for pos in arrOfPoses:
		lineHighlighter.add_point( pos.global_position, ind )
		lineHighlighter.add_point( centerPos, ind + 1 )
		ind += 2
	pass


func placePointsFromMap() -> void:
	var pointsMap: Node2D = pointMaps[ floor( pointMaps.size() * randf() ) ].instantiate()
	add_child(pointsMap)
	for pointOnPointMap in pointsMap.get_children():
		var point: Control = load("res://Scenes/UI/PitStopBtn.tscn").instantiate()
		var pointPosition: Vector2 = pointOnPointMap.global_position + randAmtToAdd()
		add_child(point)

		var pointButton: TextureButton = point.get_node("TextureButton")
		if pointButton:
			point.global_position = pointPosition
			pointButton.pressed.connect(pointPressed.bind(point))
		else:
			printerr("Error: Could not find TextureButton in PitStopBtn.tscn")
			point.queue_free()
	remove_child(pointsMap)

func pointPressed(clickedPoint: Control) -> void:
	for point in pointsConnectedToCruiserPoint():
		if point == clickedPoint:
			var dist: float = get_global_mouse_position().distance_squared_to( clickedPoint.global_position )
			if dist > clickedPoint.marg:
				moveCruiserToThisPoint( clickedPoint.global_position )
				pass

func connectPointsOnMap() -> void:
	for point in get_children():
		var pointId: int = astar.get_available_point_id()
		dictOfPoints[ pointId ] = point
		dictOfIds[ point ] = pointId
		astar.add_point( pointId, point.global_position )

	for pointId in astar.get_point_ids():
		var pointPosition := astar.get_point_position( pointId )
		var arrOfPoints := []
		var distOfPoints := []

		for secondPointId in astar.get_point_ids():
			if secondPointId != pointId:
				var secondPointPosition: Vector2 = dictOfPoints[ secondPointId ].global_position
				var dist := pointPosition.distance_squared_to(secondPointPosition)
				distOfPoints.append( dist )
				arrOfPoints.append( secondPointId )

		var sortedDistOfPoints := distOfPoints.duplicate()
		sortedDistOfPoints.sort()

		for i in range(randi_range(2, 3)):
			var indexToUse := distOfPoints.find( sortedDistOfPoints[i] )
			var idOfCurrentlyClosestPoint: int = arrOfPoints[ indexToUse ]
			astar.connect_points( pointId, idOfCurrentlyClosestPoint, true )

func _draw() -> void:
	if astar and mapDone:
		for p in astar.get_point_ids():
			for c in astar.get_point_connections(p):
				var pp = astar.get_point_position(p)
				var cp = astar.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color("ebeae6"), 2, true)


func areLeftAndRightConnected() -> void:
	var leftMostPoint: Control = getClosestPointToPosPassedIn( idealStartPos )
	var rightMostPoint: Control = getClosestPointToPosPassedIn( idealEndPos )
	
	var leftMostId: int = dictOfIds[ leftMostPoint ]
	var rightMostId: int = dictOfIds[ rightMostPoint ]

	if not(astar.get_point_path(leftMostId, rightMostId)):
		get_tree().reload_current_scene() #clears everything and reloads the map :/ there's definitely a more elegant way to do this
	pass


func placeCruiserOnLeftMostPoint() -> void:
	var leftMostPoint := getClosestPointToPosPassedIn( idealStartPos )
	if is_instance_valid(cruiser):
		if cruiser.has_method('setPos'):
			cruiser.call('setPos', leftMostPoint.global_position)


func getClosestPointToPosPassedIn(posToStartAt: Vector2) -> Control:
	var maxDist = INF
	var pointToReturn: Control
	for point in get_children():
		var dist: float = posToStartAt.distance_squared_to( point.global_position )
		if dist < maxDist:
			pointToReturn = point
			maxDist = dist
	return pointToReturn


func doneMovingCruiser() -> void:
	pointsConnectedToCruiserPoint()
	pass


func randAmtToAdd() -> Vector2:
	return Vector2( randf_range(-marg, marg) , randf_range(-marg, marg) )
