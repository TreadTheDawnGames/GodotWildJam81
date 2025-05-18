extends PlayerShip
class_name PirateShip
@onready var move_timer: Timer = $MoveTimer

var goDirection : Vector2 = Vector2(0,0)
var lrDir : float = -0.5

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
	var moveDir = goDirection.normalized()  * 25 * delta  * (GetSpeed()/5.0)
	global_position += moveDir
	ClampPosition()
	
	if(global_position.x > 1500):
		queue_free()
	
	return

func SetNewLocation():
	goDirection = Vector2(lrDir, randf()-randf())
	move_timer.start(randf_range(0.5,1.0))
	return

func DamageRoom(amount : int, _checkParent : bool = false):
	hitpoints -= amount
	
	if(hitpoints <=0):
		GlobalPlayerInfo.Shake()
		queue_free()
		return true
	return
