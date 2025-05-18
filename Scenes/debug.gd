extends Node2D
class_name GameRoot

const shopScene = preload("res://Scenes/ShipBuilder/shipyard.tscn")
const mainMenuScene = preload("res://Scenes/UI/MainMenu.tscn")
var mainMenu: MainMenu
const optionsMenuScene = preload("res://Scenes/UI/Options.tscn")
var optionsMenu: OptionsMenu
const LEVEL = preload("res://Scenes/LevelScenes/level.tscn")
var space_map: SpaceMap
@onready var shipSpawnMarker: Marker2D = $playerShipSpawn
const SPACE_MAP = preload("res://Scenes/UI/SpaceMap.tscn")

var DEBUGcurrentLevel

var flightSpeed : int = 1

func _ready():
	loadGameSettings()
	get_node("PlayerShip").EnterStorage()
	ResetMap()
	TransitionToMainMenu()
	GlobalPlayerInfo.AddMoney(20)
	Background.StopScroll()

func loadGameSettings():
	var gameSettings = GameSettings.loadConfigValues()
	var sfxBusIndex = AudioServer.get_bus_index("SFX")
	var musicBusIndex = AudioServer.get_bus_index("Music")
	var masterBusIndex = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(
		sfxBusIndex,
		linear_to_db(gameSettings.SFX)
	)
	AudioServer.set_bus_volume_db(
		musicBusIndex,
		linear_to_db(gameSettings.Music)
	)
	AudioServer.set_bus_volume_db(
		masterBusIndex,
		linear_to_db(gameSettings.Master)
	)

func TransitionToLevel():
	Engine.time_scale = flightSpeed
	space_map.hide()
	GlobalPlayerInfo.ShipExitStorage(shipSpawnMarker.global_position)
	var level = LEVEL.instantiate() as Level
	level.info = GlobalPlayerInfo.ActiveLevelInfo
	add_child(level)
	GlobalPlayerInfo.ActiveLevel = level
	level.LevelComplete.connect(TransitionToShop)
	return

func TransitionToShop():
	Engine.time_scale = 1
	if(GlobalPlayerInfo.ActiveLevelInfo and GlobalPlayerInfo.ActiveLevelInfo.FinalLevel):
		GlobalPlayerInfo.EndGame(true)
		return
	flightSpeed = GlobalPlayerInfo.ThePlayerShip.GetSpeed()
	var shop = shopScene.instantiate()
	add_child(shop)
	shop.ShopClosed.connect(TransitionToSpaceMap)
	return

func TransitionToMainMenu():
	mainMenu = mainMenuScene.instantiate()
	add_child(mainMenu)
	mainMenu.StartClicked.connect(TransitionToShop)
	mainMenu.StartClicked.connect(KillMainMenu)
	mainMenu.OptionsClicked.connect(TransitionToOptionsMenu)
	mainMenu.OptionsClicked.connect(KillMainMenu)
	mainMenu.QuitGame.connect(CloseGame)
	return

func TransitionToOptionsMenu():
	optionsMenu = optionsMenuScene.instantiate()
	add_child(optionsMenu)
	optionsMenu.QuitOptions.connect(TransitionToMainMenu)
	optionsMenu.QuitOptions.connect(KillOptionsMenu)
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

func KillMainMenu():
	if(mainMenu):
		mainMenu.queue_free()
	return

func KillOptionsMenu():
	if(optionsMenu):
		optionsMenu.queue_free()
	return

func CloseGame():
	get_tree().quit()
