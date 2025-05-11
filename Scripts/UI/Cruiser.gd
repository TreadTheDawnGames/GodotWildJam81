extends Node2D

signal doneMoving

var cruiserTween: Tween

func _ready() -> void:
	cruiserTween = get_tree().create_tween().bind_node(self)

func tweenDone() -> void:
	doneMoving.emit()

func moveTo(posToMoveTo: Vector2) -> void:
	cruiserTween.tween_property(self, "global_position", posToMoveTo, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	cruiserTween.tween_callback(tweenDone)
	
func setPos(posToSetTo: Vector2) -> void:
	global_position = posToSetTo
