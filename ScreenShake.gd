#https://www.youtube.com/watch?v=LGt-jjVf-ZU
extends Camera2D
class_name ScreenShake

@export var randomStrength: float = 10.0
@export var shakeFade: float = 10.0

var rng = RandomNumberGenerator.new()

var shake_str: float = 0.0

func Shake():
	shake_str = randomStrength

func _process(delta: float) -> void:
	
	if(shake_str >0):
		shake_str = lerpf(shake_str,0,shakeFade*delta)
		offset = RandomOffset()

func RandomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_str, shake_str), rng.randf_range(-shake_str, shake_str))
