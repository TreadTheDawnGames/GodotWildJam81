extends Control

# Thanks to this gentleman for helping me understand popups
# https://www.youtube.com/watch?app=desktop&v=Q8oee9tRMSc

func showPitStopPopup(slot: Rect2i, popuptext: String) -> void:
	var mousePos = get_viewport().get_mouse_position()
	var correction
	var padding = 4
	%MissionInfo.text = popuptext
	
	if mousePos.x <= get_viewport_rect().size.x / 2:
		correction = Vector2i(slot.size.x + padding, 0)
	else:
		correction = -Vector2i(%PitStopPopUp.size.x + padding, 0)
	%PitStopPopUp.popup(Rect2i( slot.position + correction, %PitStopPopUp.size ))
	return

func hidePitStopPopup() -> void:
	%PitStopPopUp.hide()
