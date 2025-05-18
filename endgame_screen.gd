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
		headline.text = winHeadline
		article.text = winArticle
	else:
		headline.text = loseHeadline
		article.text = loseArticle
	
	button.pressed.connect(func(): 
		GlobalPlayerInfo.ResetValues()
		GlobalPlayerInfo.GetGameRoot().TransitionToShop()
		GlobalPlayerInfo.GetGameRoot().ResetMap()
		queue_free()
		)
	
	reputation.text = "Your Reputation: " + str(GlobalPlayerInfo.Reputation)
		#https://forum.godotengine.org/t/how-to-show-on-a-label-how-much-time-from-a-timer-is-left/13594
	total_time.text = "Time Traveled: %d:%02d" % [floor(GlobalPlayerInfo.TotalTime / 60.0), int(GlobalPlayerInfo.TotalTime) % 60]
