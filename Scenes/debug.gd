extends Node2D
class_name GameRoot

const shopScene = preload("res://Scenes/ShipBuilder/shipyard.tscn")
const LEVEL = preload("res://Scenes/LevelScenes/level.tscn")
var space_map: SpaceMap
@onready var shipSpawnMarker: Marker2D = $playerShipSpawn
const SPACE_MAP = preload("res://Scenes/UI/SpaceMap.tscn")

var DEBUGcurrentLevel

var flightSpeed : int = 1

func _ready():
	get_node("PlayerShip").EnterStorage()
	ResetMap()
	GlobalPlayerInfo.AddMoney(20)
	TransitionToShop()

func TransitionToLevel():
	Engine.time_scale = flightSpeed
	print("Arrived")
	space_map.hide()
	GlobalPlayerInfo.ShipExitStorage(shipSpawnMarker.global_position)
	var level = LEVEL.instantiate() as Level
	level.info = GlobalPlayerInfo.ActiveLevelInfo
	add_child(level)
	GlobalPlayerInfo.ActiveLevel = level
	level.LevelComplete.connect(TransitionToShop)
	return

func TransitionToShop():
	if(GlobalPlayerInfo.ActiveLevelInfo and GlobalPlayerInfo.ActiveLevelInfo.FinalLevel):
		GlobalPlayerInfo.EndGame(true)
		return
	flightSpeed = GlobalPlayerInfo.ThePlayerShip.GetSpeed()
	var shop = shopScene.instantiate()
	add_child(shop)
	shop.ShopClosed.connect(TransitionToSpaceMap)
	return

func TransitionToSpaceMap():
	Engine.time_scale = 1
	GlobalPlayerInfo.ShipEnterStorage()
	space_map.show()

func ResetMap():
	if(space_map):
		space_map.queue_free()
	space_map = SPACE_MAP.instantiate()
	add_child(space_map)
	space_map.hide()
	space_map.cruiser.doneMoving.connect(TransitionToLevel)
	
	return
