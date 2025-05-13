extends PanelContainer


func _on_mouse_entered() -> void:
	Popups.showPitStopPopup(Rect2i( Vector2i(global_position), Vector2i(size) ), '')


func _on_mouse_exited() -> void:
	Popups.hidePitStopPopup()
