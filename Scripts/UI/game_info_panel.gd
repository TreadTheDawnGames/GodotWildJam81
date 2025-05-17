extends Sprite2D
class_name GameInfoPanel

@onready var money_label: RichTextLabel = $MoneyLabel
@onready var crew_count_label: RichTextLabel = $CrewCountLabel
@onready var firepower_label: RichTextLabel = $FirepowerLabel
@onready var speed_label: RichTextLabel = $SpeedLabel
@onready var time_left: RichTextLabel = $TimeLeft
@onready var dust_label: RichTextLabel = $DustLabel


func _ready() -> void:
	UpdateText()

func UpdateText():
	var ship : PlayerShip = GlobalPlayerInfo.ThePlayerShip
	if(!ship):
		printerr("There is no global playership!")
		return
	money_label.text = "Money: " + str(GlobalPlayerInfo.Money)
	crew_count_label.text = "Crew: " + str(ship.GetCrewCount())
	firepower_label.text = "Firepower: " + str(ship.GetFirepower())
	speed_label.text = "Speed: " + str(ship.GetSpeed())
	if(GlobalPlayerInfo.ActiveLevel and !GlobalPlayerInfo.ActiveLevel.complete):
		var timer = GlobalPlayerInfo.ActiveLevel.level_timer
		var dustAmount = "Dust: " + str(GlobalPlayerInfo.ActiveLevelInfo.SpaceDust) + "%"
	#https://forum.godotengine.org/t/how-to-show-on-a-label-how-much-time-from-a-timer-is-left/13594
		time_left.text = "%d:%02d" % [floor(timer.time_left / 60), int(timer.time_left) % 60]
		dust_label.text = dustAmount
	else:
		time_left.text = "X:XX"
		dust_label.text = "Dust: N/A"

	
	
	return

func _process(_delta: float) -> void:
	UpdateText()
