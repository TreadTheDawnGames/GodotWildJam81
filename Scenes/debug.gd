extends Node2D

const shopScene = preload("res://Scenes/ShipBuilder/shipyard.tscn")
const LEVEL = preload("res://Scenes/LevelScenes/level.tscn")
@onready var space_map: SpaceMap = $SpaceMap
@onready var shipSpawnMarker: Marker2D = $playerShipSpawn

var DEBUGcurrentLevel

var flightSpeed : int = 1

func _ready():
	get_node("PlayerShip").EnterStorage()
	space_map.cruiser.doneMoving.connect(TransitionToLevel)
	GlobalPlayerInfo.AddMoney(20)
	TransitionToShop()

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("DEBUG-SpawnPlayerShip")):
		GlobalPlayerInfo.ShipExitStorage(global_position )
		print("Spawning ship")
	if(Input.is_action_just_pressed("DEBUG-AddMoney")):
		GlobalPlayerInfo.AddMoney(20)
	if(Input.is_action_just_pressed("DEBUG-RandomLevel")):
		if(DEBUGcurrentLevel):
			GlobalPlayerInfo.UnsetActiveLevel()
			DEBUGcurrentLevel.queue_free()
		DEBUGcurrentLevel = LEVEL.instantiate()
		DEBUGcurrentLevel.info = LevelInfo.generateRandomLevel(randi()%2==0)
		add_child(DEBUGcurrentLevel)
		GlobalPlayerInfo.SetActiveLevel(DEBUGcurrentLevel)
		
	if(Input.is_action_just_pressed("DEBUG-CloseLevel")):
		GlobalPlayerInfo.UnsetActiveLevel()
		if(DEBUGcurrentLevel):
			DEBUGcurrentLevel.queue_free()
		Background.StopScroll()


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
	flightSpeed = GlobalPlayerInfo.ThePlayerShip.GetSpeed()
	var shop = shopScene.instantiate()
	add_child(shop)
	shop.ShopClosed.connect(TransitionToSpaceMap)
	return

func TransitionToSpaceMap():
	Engine.time_scale = 1
	GlobalPlayerInfo.ShipEnterStorage()
	space_map.show()
