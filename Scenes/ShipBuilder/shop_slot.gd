extends Marker2D
class_name ShopSlot

@onready var priceText: RichTextLabel = $Panel/RichTextLabel

func setPrice(price : int):
	priceText.text = "Price: $" + str(price)
