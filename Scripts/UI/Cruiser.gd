extends Node2D

signal doneMoving

func tweenDone() -> void:
	doneMoving.emit()

func moveTo(posToMoveTo: Vector2) -> void:
	var cruiserTween: Tween = get_tree().create_tween().bind_node(self)
	cruiserTween.tween_property(self, "global_position", posToMoveTo, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	cruiserTween.tween_callback(tweenDone)
	$MoveCruiserSound.play()
	
func setPos(posToSetTo: Vector2) -> void:
	global_position = posToSetTo
