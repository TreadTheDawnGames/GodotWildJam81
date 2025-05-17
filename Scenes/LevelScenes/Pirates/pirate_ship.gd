extends PlayerShip
class_name PirateShip

func _ready():
	dragNDrop = false
	Setup.call_deferred()
	for cell : ConnectionCell in positionIndexedChildren.values().filter(func(a): return a is ConnectionCell):
		cell.grabArea.set_collision_layer_value(2, false)
	#super._ready()
	Faction = ShipFaction.Enemy
	return

func _process(_delta: float) -> void:
	return
