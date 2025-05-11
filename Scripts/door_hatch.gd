extends TDCardPlayArea
class_name DoorHatch

@onready var ConnectionSlot = $TDCardPositionMarker2D
@export var interiorDoor = false

func _ready() -> void:
	if(interiorDoor):
		monitorable = false
		monitoring = false
