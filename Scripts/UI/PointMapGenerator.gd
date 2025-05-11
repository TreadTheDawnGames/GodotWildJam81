extends Node2D

const pointMaps := [
	preload("res://Scenes/UI/PointMaps/PointMap1.tscn"),
	preload("res://Scenes/UI/PointMaps/PointMap2.tscn"),
	preload("res://Scenes/UI/PointMaps/PointMap3.tscn"),
]
const idealStartPos := Vector2( 0, 300 )
const idealEndPos := Vector2( 1024, 300 )
var marg := 25
var cruiser: Node2D
var mapDone := false
var astar := AStar2D.new()
var dictOfPoints: Dictionary = {}
var dictOfIds: Dictionary = {}

func _ready() -> void:
	randomize()
	cruiser = get_parent().get_node("Cruiser")
	#cruiser.connect( 'doneMoving', doneMovingCruiser )
	makeMap()


func makeMap() -> void:
	placePointsFromMap()
	connectPointsOnMap(2)
	areLeftAndRightConnected()
	placeCruiserOnLeftMostPoint()
	mapDone = true


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed('click'):
		#print(get_global_mouse_position())
		#for point in pointsConnectedToCruiserPoint():
			#var dist: float = get_global_mouse_position().distance_squared_to( point.global_position )
			#if dist < point.marg:
				#moveCruiserToThisPoint( point.global_position )


func pointsConnectedToCruiserPoint() -> Array:
	var arrOfConnectedPoints: Array
	var pointToGetConnectionsOf: Control = getClosestPointToPosPassedIn( cruiser.global_position )
	var idOfPointToGetConnectionsOf: int = dictOfIds[ pointToGetConnectionsOf ]
	
	var arrOfPointIdThatAreConnectedToTheMainPoint = astar.get_point_connections( idOfPointToGetConnectionsOf )
	for id in arrOfPointIdThatAreConnectedToTheMainPoint:
		arrOfConnectedPoints.append( dictOfPoints[ id ] )
	return arrOfConnectedPoints

func moveCruiserToThisPoint(pos: Vector2) -> void:
	cruiser.moveTo(pos)

func placePointsFromMap() -> void:
	var pointsMap: Node2D = pointMaps[ floor( pointMaps.size() * randf() ) ].instantiate()
	add_child(pointsMap)
	for pointOnPointMap in pointsMap.get_children():
		var point: Control = load("res://Scenes/UI/PitStopBtn.tscn").instantiate()
		add_child(point)
		var pointButton: TextureButton = point.get_node("TextureButton")
		point.global_position = pointOnPointMap.global_position + randAmtToAdd()
		pointButton.pressed.connect(pointPressed.bind(point))
	remove_child(pointsMap)

func pointPressed(clickedPoint: Control) -> void:
	for point in pointsConnectedToCruiserPoint():
		if point == clickedPoint:
			var dist: float = get_global_mouse_position().distance_squared_to( clickedPoint.global_position )
			if dist > clickedPoint.marg:
				moveCruiserToThisPoint( clickedPoint.global_position )
				pass

func connectPointsOnMap(numToConnectWith: int = 1) -> void:
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

		for i in range(numToConnectWith):
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

func randAmtToAdd() -> Vector2:
	return Vector2( randf_range(-marg, marg) , randf_range(-marg, marg) )
