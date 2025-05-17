extends PlayerShip
class_name PirateShip
@onready var move_timer: Timer = $MoveTimer

var goDirection : Vector2 = Vector2(0,0)


func _ready():
	editing = true
	dragNDrop = false
	Setup.call_deferred()
	for cell : ConnectionCell in positionIndexedChildren.values().filter(func(a): return a is ConnectionCell):
		cell.grabArea.set_collision_layer_value(2, false)
	#super._ready()
	Faction = ShipFaction.Enemy
	move_timer.timeout.connect(SetNewLocation)
	SetNewLocation()
	return

func _process(delta: float) -> void:
	if(editing):
		return
		
	if(global_position.y > -324):
		if(goDirection.y > 1):
			goDirection*=-1
	var moveDir = goDirection.normalized() * GetSpeed() * 25 * delta
	global_position += moveDir
	print(GetSpeed())
	ClampPosition()
	return

func SetNewLocation():
	goDirection = Vector2(-0.5, randf()-randf())
	move_timer.start(randf_range(0.5,1.0))
	return
