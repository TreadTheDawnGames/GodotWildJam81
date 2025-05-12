extends ConnectionPlayArea

@export var doorNormal : Texture2D
@export var doorConnectable : Texture2D


func ValidConnection():
	sprite.texture = doorConnectable #.blend(Color.BLACK)
	return

func ValidConnectionOff():
	sprite.texture = doorNormal #.blend(Color.BLACK)
	return
