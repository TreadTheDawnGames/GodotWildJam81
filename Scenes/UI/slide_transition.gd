extends CanvasLayer

signal Halfway

func _ready():
	$AnimationPlayer.animation_finished.connect(
		func(animation): 
			if(animation == "SlidePart1"):
				Halfway.emit()
				$AnimationPlayer.play("SlidePart2"))

func EmitOnHalfway():
	$AnimationPlayer.play("SlidePart1")
	return
