extends PanelContainer


func _on_mouse_entered() -> void:
	Popups.showPitStopPopup('')


func _on_mouse_exited() -> void:
	Popups.hidePitStopPopup()
