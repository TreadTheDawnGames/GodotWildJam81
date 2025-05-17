extends Cell

var active : bool = false
@export var fireRate : float = 1.0
@onready var shotTimer: Timer = $Timer
@onready var laserInstantiationPoint: Marker2D = $LaserInstantiationPoint

@export var AMMO : PackedScene
@export var curve : Curve
func Init() -> void:
	super.Init()
	var neighbors = GetNeighbors()
	for neighbor in neighbors:
		var neighborCell : Cell = Map.GetChildByCoords(neighbor)
		if(neighborCell is ConnectionCell):
			match(myCoords - neighbor):
				Vector2i.RIGHT:
					neighborCell.RemoveConnection(neighborCell.Direction.East)
				Vector2i.LEFT:
					neighborCell.RemoveConnection(neighborCell.Direction.West)
				Vector2i.UP:
					neighborCell.RemoveConnection(neighborCell.Direction.North)
				Vector2i.DOWN:
					neighborCell.RemoveConnection(neighborCell.Direction.South)

	shotTimer.timeout.connect(ShootLaser)
	reparent(Map)
	$Sprite2D.queue_free()

	return

func ShootLaser():
	if(Map is PlayerShip and Map.editing):
		return
	var laser = AMMO.instantiate()
	#(clamp(
	var speedMultiplier : float = curve.sample((float(GlobalPlayerInfo.ActiveLevel.info.SpaceDust)/100.0 ) if GlobalPlayerInfo.ActiveLevel else 0)
	shotTimer.wait_time = fireRate * speedMultiplier
	laser.global_position = laserInstantiationPoint.global_position
	get_tree().root.add_child(laser)
	return

func ConnectedToShipFunc():
	shotTimer.start()
	return
