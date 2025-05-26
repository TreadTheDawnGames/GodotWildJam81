extends Sprite2D
class_name PlanetSprite

var inView : bool = false

func _process(delta: float) -> void:
	if(inView):
		@warning_ignore("integer_division")
		position.x -= 20 * delta * (GlobalPlayerInfo.ThePlayerShip.GetSpeed()/2)

func Move():
	inView = true
	return
