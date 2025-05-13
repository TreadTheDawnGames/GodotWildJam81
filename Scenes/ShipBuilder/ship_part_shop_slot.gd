extends Node2D
class_name ShopSlot

@onready var CostLabel: RichTextLabel = $RichTextLabel
@onready var shopSlot : TDCardPositionMarker2D = $TDCardPositionMarker2D

func AssignPart(part : ShipPart):
	CostLabel.text = part.partName + ": $" + str(part.price)
	part.FillMarker(shopSlot)
