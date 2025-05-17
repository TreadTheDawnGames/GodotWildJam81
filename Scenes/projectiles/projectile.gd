extends Area2D
class_name Laser

@export var speed : int = 500

var direction : int = 1

func _ready() -> void:
	area_entered.connect(HitSomething)

func _process(delta: float) -> void:
	global_position.x += speed * delta * direction
	if(global_position.x > 1150):
		queue_free()

func HitSomething(area : Area2D):
	if(area is Asteroid):
		var ast : Asteroid = area as Asteroid
		ast.TakeDamage(1)
		queue_free()
	if(area.owner is ConnectionCell):
		var room = area.owner.get_parent() as ShipRoom
		room.DamageRoom(1)
		queue_free()
	return
