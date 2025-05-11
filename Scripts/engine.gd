extends TDCardPlayArea
class_name ThrusterEngine

@onready var ConnectionSlot = $TDCardPositionMarker2D

func _ready():
	ConnectionSlot = get_node("TDCardPositionMarker2D")
