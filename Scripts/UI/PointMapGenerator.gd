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
var dictOfPitStops: Dictionary = {}
var dictOfIds: Dictionary = {}

func _ready() -> void:
	randomize()
	cruiser = get_parent().get_node("Cruiser")
	#cruiser.connect( 'doneMoving', doneMovingCruiser )
	makeMap()


func makeMap() -> void:
	placePointsFromMap()
	connectPointsOnMap(2)
	#await get_tree()
	areLeftAndRightConnected()
	#await get_tree()
	#update()
	#placeCruiserOnLeftMostPoint()
	mapDone = true


func placePointsFromMap() -> void:
	var pitStopsMap: Node2D = pointMaps[ floor( pointMaps.size() * randf() ) ].instantiate()
	add_child(pitStopsMap)
	for pitStopOnPointMap in pitStopsMap.get_children():
		var pitStop: Control = load("res://Scenes/UI/PitStopBtn.tscn").instantiate()
		add_child(pitStop)
		pitStop.global_position = pitStopOnPointMap.global_position + randAmtToAdd()
	remove_child(pitStopsMap)


func connectPointsOnMap(numToConnectWith: int = 1) -> void:
	for pitStop in get_children():
		var pitStopId: int = astar.get_available_point_id()
		dictOfPitStops[ pitStopId ] = pitStop
		dictOfIds[ pitStop ] = pitStopId
		astar.add_point( pitStopId, pitStop.global_position )

	for pitStopId in astar.get_point_ids():
		var pitStopPosition := astar.get_point_position( pitStopId )
		var arrOfPitStops := []
		var distOfPitStops := []

		for secondPitStopId in astar.get_point_ids():
			if secondPitStopId != pitStopId:
				var secondPitStopPosition: Vector2 = dictOfPitStops[ secondPitStopId ].global_position
				var dist := pitStopPosition.distance_squared_to(secondPitStopPosition)
				distOfPitStops.append( dist )
				arrOfPitStops.append( secondPitStopId )

		var sortedDistOfPitStops := distOfPitStops.duplicate()
		sortedDistOfPitStops.sort()

		for i in range(numToConnectWith):
			var indexToUse := distOfPitStops.find( sortedDistOfPitStops[i] )
			var idOfCurrentlyClosestPoint: int = arrOfPitStops[ indexToUse ]
			astar.connect_points( pitStopId, idOfCurrentlyClosestPoint, true )

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
