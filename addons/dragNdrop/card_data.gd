class_name TDCardData

var CardName : String
var discardable : bool
var playable : bool
var PlayType : String


func _init(cardName : String, playType : String) -> void:
	CardName = cardName
	PlayType = playType
	return
	
func _to_string() -> String:
	var other = "null"
	return "Name: " + CardName + " | Value: " + other

func SpecialSetup(_card : TDCard):
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: SpecialSetup has not been implemented. card: " + CardName)
	return

func Frame(_card : TDCard, _delta : float) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: Frame has not been implemented. card: " + CardName)
	return

## Called every frame while the cursor is hovered over the associated TDCard.
func WhileHovered(_card : TDCard):
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: WhileHovered has not been implemented. card: " + CardName)
	return

func HoverEnterAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: HoverEnterAction has not been implemented. card: " + card.cardName)
	return

func GrabAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it:  GrabAction has not been implemented. card: " + card.cardName)
	return

func EnterUsable(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func Preplay(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func PlayCard(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: PlayCard has not been implemented. card: " + card.cardName + " playType: " + playType)
	return

func Postplay(_playArea : TDCardPlayArea, _card : TDCard) -> void:
	return

func ExitUsable(_card : TDCard) -> void:
	return

func DropAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: DropAction has not been implemented. card: " + card.cardName)
	return

func HoverExitAction(_card : TDCard) -> void:
	#printerr("[CardData] CardData is intended to be used as an abstract class. Please create a new class and inherit it: HoverExitAction has not been implemented. card: " + card.cardName)
	return
