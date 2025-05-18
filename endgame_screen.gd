extends Node2D
class_name EndgameScreen

@export var winHeadline : String
@export var winArticle : String
@export var loseHeadline : String
@export var loseArticle : String

@onready var headline: RichTextLabel = $Headline
@onready var reputation: RichTextLabel = $Reputation
@onready var article: RichTextLabel = $Article
@onready var total_time: RichTextLabel = $TotalTime
@onready var button: Button = $Button

var Win : bool = false

func _ready() -> void:
	if(Win):
		headline.text = winHeadline.replace("[/br]", "\n\n").replace("[num]", RomanNumeralize(GlobalPlayerInfo.retryCount))
		article.text = winArticle
	else:
		headline.text = loseHeadline
		article.text = loseArticle.replace("[/br]", "\n\n").replace("[num]", RomanNumeralize(GlobalPlayerInfo.retryCount))
	
	button.pressed.connect(func(): 
		GlobalPlayerInfo.ResetValues()
		#GlobalPlayerInfo.GetGameRoot().TransitionToShop()
		#GlobalPlayerInfo.GetGameRoot().ResetMap()
		queue_free()
		)
	
	reputation.text = "Your Reputation: " + str(GlobalPlayerInfo.Reputation + GlobalPlayerInfo.ThePlayerShip.GetCrewCount())
		#https://forum.godotengine.org/t/how-to-show-on-a-label-how-much-time-from-a-timer-is-left/13594
	total_time.text = "Time Traveled: %d:%02d" % [floor(GlobalPlayerInfo.TotalTime / 60.0), int(GlobalPlayerInfo.TotalTime) % 60]

func RomanNumeralize(num : int) -> String:
	var returnStr : String = ""
	if(num > 0):
		returnStr+=" "
	match(num+1):
		0:
			returnStr = ""
		1:
			returnStr += ""
		2:
			returnStr += "II"
		3:
			returnStr += "III"
		4:
			returnStr += "IV"
		5:
			returnStr += "V"
		6:
			returnStr += "VI"
		7:
			returnStr += "VII"
		8:
			returnStr += "VIII"
		9:
			returnStr += "IX"
		10:
			returnStr += "X"
		11:
			returnStr += "XI"
		12:
			returnStr += "XII"
		13:
			returnStr += "XIII"
		14:
			returnStr += "XIV"
		15:
			returnStr += "XV"
		16:
			returnStr += "XVI"
		17:
			returnStr += "XVII"
		18:
			returnStr += "XVIII"
		19:
			returnStr += "XIX"
		20:
			returnStr += "XX"
		_:
			returnStr += str(num)
	
	return returnStr
