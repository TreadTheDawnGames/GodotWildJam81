extends Node

const ENDGAME_SCREEN = preload("res://Scenes/endgame_screen.tscn")

var ThePlayerShip : PlayerShip
var ActiveLevelInfo : LevelInfo
var ActiveLevel : Level
var Money : int = 20
var Reputation : int

var TotalTime : float

var retryCount:int=0

func AddRep(amount : int):
	Reputation += amount

func AddMoney(amount : int):
	Money += amount
	Money = clamp(Money, 0, 9999)
	return
	
func RemoveMoney(amount : int):
	if(CanRemoveMoney(amount)):
		AddMoney(-amount)
		return true
	return false

func SetActiveLevelInfo(level : LevelInfo):
	ActiveLevelInfo = level
	
func UnsetActiveLevel():
	ActiveLevel = null

func CanRemoveMoney(amount : int) -> bool:
	return Money - amount >= 0
	
func SetPlayerShip(ship : PlayerShip):
	ThePlayerShip = ship
	
func ShipEnterStorage():
	ThePlayerShip.EnterStorage()
	
func ShipExitStorage(position : Vector2) -> PlayerShip:
	if(!ThePlayerShip):
		#printerr("THERE IS NO PLAYER SHIP")
		return
	ThePlayerShip.global_position = position
	ThePlayerShip.process_mode = Node.PROCESS_MODE_PAUSABLE
	return ThePlayerShip

func EndGame(win : bool):
	var end : EndgameScreen = ENDGAME_SCREEN.instantiate()
	end.Win = win
	add_child(end)
	GlobalPlayerInfo.ShipEnterStorage()
	return

func ResetValues():
	for room in ThePlayerShip.SubMaps:
		if(is_instance_valid(room)):
			room.DamageRoom(room.hitpoints+1)
	ThePlayerShip.positionIndexedChildren.clear()
	ThePlayerShip.isSetup = false
	ThePlayerShip.Setup()
	ActiveLevelInfo = null
	ActiveLevel = null
	Money = 20
	Reputation = 0
	TotalTime = 0
	retryCount+=1

func GetGameRoot() -> GameRoot:
	return get_tree().root.get_children().filter(func(a): return a is GameRoot)[0]

func Shake():
	GetGameRoot().get_node("GameCamera").Shake()
