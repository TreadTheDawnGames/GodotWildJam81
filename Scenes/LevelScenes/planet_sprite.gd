extends Sprite2D
class_name PlanetSprite

var inView : bool = false

func _process(delta: float) -> void:
	if(inView):
		position.x -= 20 * delta

func Move():
	inView = true
	return
