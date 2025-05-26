extends Button

func _ready():
	pressed.connect(func(): get_child(0).show())
	return
