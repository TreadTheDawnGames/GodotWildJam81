extends Control

func _ready():
	gui_input.connect(GoAway)
	

func GoAway(event: InputEvent):
	if(event.is_action("click")):
		print("clicked")
		hide()
	return
