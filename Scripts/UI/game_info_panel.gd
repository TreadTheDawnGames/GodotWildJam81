extends Sprite2D
class_name GameInfoPanel

@onready var money_label: RichTextLabel = $MoneyLabel
@onready var crew_count_label: RichTextLabel = $CrewCountLabel
@onready var firepower_label: RichTextLabel = $FirepowerLabel
@onready var speed_label: RichTextLabel = $SpeedLabel


func _ready() -> void:
	UpdateText()

func UpdateText():
	var ship : PlayerShip = GlobalPlayerInfo.ThePlayerShip
	if(!ship):
		printerr("There is no global playership!")
		return
	print("Text updated")
	money_label.text = "Money: " + str(GlobalPlayerInfo.Money)
	crew_count_label.text = "Crew: " + str(ship.GetCrewCount())
	firepower_label.text = "Firepower: " + str(ship.GetFirepower())
	speed_label.text = "Speed: " + str(ship.GetSpeed())
	return
