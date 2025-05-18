extends Control
class_name SpaceMap

var cruiser : Cruiser
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%SpaceMapBGM
	cruiser = get_node("Cruiser")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
