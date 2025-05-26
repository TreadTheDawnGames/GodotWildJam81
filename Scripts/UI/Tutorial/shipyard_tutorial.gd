extends Control
@onready var check_button: CheckButton = $CheckButton

func _ready():
	if(GlobalPlayerInfo.hideTutorials):
		hide()
	check_button.toggled.connect(func(ticked): GlobalPlayerInfo.hideTutorials = ticked)
	gui_input.connect(GoAway)
	

func Setup(hideMe : bool):
	if(hideMe):
		hide()
	check_button.button_pressed = GlobalPlayerInfo.hideTutorials

func GoAway(event: InputEvent):
	if(event.is_action("click")):
		print("clicked")
		hide()
	return
