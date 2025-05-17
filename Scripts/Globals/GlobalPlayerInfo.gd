extends Node

var ThePlayerShip : PlayerShip
var ActiveLevel : Level
var Money : int

func AddMoney(amount : int):
	Money += amount
	Money = clamp(Money, 0, 9999)
	return
	
func RemoveMoney(amount : int):
	if(CanRemoveMoney(amount)):
		AddMoney(-amount)
		return true
	return false

func SetActiveLevel(level : Level):
	ActiveLevel = level
	
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
		printerr("THERE IS NO PLAYER SHIP")
		return
	ThePlayerShip.global_position = position
	ThePlayerShip.process_mode = Node.PROCESS_MODE_PAUSABLE
	print("Spawned ship")
	return ThePlayerShip
