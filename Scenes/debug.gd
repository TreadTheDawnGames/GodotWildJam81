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
	GlobalPlayerInfo.AddMoney(50)
	TransitionToMainMenu()
	Background.StopScroll()
	GlobalPlayerInfo.ThePlayerShip.EnteredPlanet.connect(TransitionToShop)

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





func TransitionToMainMenu():
	SlideTransition.EmitOnHalfway()
	
	for dict in SlideTransition.Halfway.get_connections():
		SlideTransition.Halfway.disconnect(dict.callable)

	SlideTransition.Halfway.connect(func(): 
		stopAllMusic()
		BackgroundMusic.get_child(0).play()
		mainMenu = mainMenuScene.instantiate()
		add_child(mainMenu)
		mainMenu.StartClicked.connect(TransitionToShop)
		mainMenu.OptionsClicked.connect(TransitionToOptionsMenu)
		mainMenu.QuitGame.connect(CloseGame)
		return)

func TransitionToOptionsMenu():
	optionsMenu = optionsMenuScene.instantiate()
	add_child(optionsMenu)
	optionsMenu.QuitOptions.connect(TransitionToMainMenu)
	optionsMenu.QuitOptions.connect(KillOptionsMenu)
	KillMainMenu()
	return


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

func TransitionToShop():
	
	SlideTransition.EmitOnHalfway()
	
	for dict in SlideTransition.Halfway.get_connections():
		SlideTransition.Halfway.disconnect(dict.callable)

	SlideTransition.Halfway.connect(func(): 
		if(GlobalPlayerInfo.ActiveLevel):
			GlobalPlayerInfo.ActiveLevel.queue_free()
		if(GlobalPlayerInfo.CurrShop):
			GlobalPlayerInfo.CurrShop.queue_free()
		KillMainMenu()
		for laser in get_tree().root.get_children().filter(func(a): return a is Laser):
			laser.queue_free()
		#check to see if the player just played the final level, and if they did, tell them they won.
		if(GlobalPlayerInfo.ActiveLevelInfo and GlobalPlayerInfo.ActiveLevelInfo.FinalLevel):
			GlobalPlayerInfo.EndGame(true)
			return
		flightSpeed = GlobalPlayerInfo.ThePlayerShip.GetSpeed()
		var shop = shopScene.instantiate()
		add_child(shop)
		shop.ShopClosed.connect(TransitionToSpaceMap)
		shop.tutorial.Setup(GlobalPlayerInfo.hideTutorials))
	return

func TransitionToSpaceMap():
	
	
	SlideTransition.EmitOnHalfway()
	
	for dict in SlideTransition.Halfway.get_connections():
		SlideTransition.Halfway.disconnect(dict.callable)

	SlideTransition.Halfway.connect(func(): 
		stopAllMusic()
		BackgroundMusic.get_child(1).play()
		GlobalPlayerInfo.ShipEnterStorage()
		if(GlobalPlayerInfo.CurrShop):
			GlobalPlayerInfo.CurrShop.queue_free()
			GlobalPlayerInfo.CurrShop = null
			GlobalPlayerInfo.ThePlayerShip.EnterStorage()
		space_map.show()
		space_map.spacemap_tutorial.Setup(GlobalPlayerInfo.hideTutorials))
		
func TransitionToLevel():
	SlideTransition.EmitOnHalfway()
	
	for dict in SlideTransition.Halfway.get_connections():
		SlideTransition.Halfway.disconnect(dict.callable)

	SlideTransition.Halfway.connect(func(): 
		stopAllMusic()
		BackgroundMusic.get_child(2).play()
		space_map.hide()
		GlobalPlayerInfo.ShipExitStorage(shipSpawnMarker.global_position)
		var level = LEVEL.instantiate() as Level
		level.info = GlobalPlayerInfo.ActiveLevelInfo
		add_child(level)
		GlobalPlayerInfo.ActiveLevel = level
		level.LevelComplete.connect(func(): GlobalPlayerInfo.ThePlayerShip.EnterPlanetAnimation = true)
		return)


func GoToPlanetAnimation():
	return

func KillOptionsMenu():
	if(optionsMenu):
		optionsMenu.queue_free()
	return

func stopAllMusic():
	var backgroundSongs = BackgroundMusic.get_children()
	for song in backgroundSongs:
		song.stop()
	return

func CloseGame():
	get_tree().quit()
