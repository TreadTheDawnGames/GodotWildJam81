extends Sprite2D
class_name RoomChooser

### Marker2D array
var slots : Array

@export var RoomDirectory : String = "res://Scenes/ShipTilemapScenes/Rooms/"

func _ready() -> void:
	slots = get_children().filter(func(a): return a is Marker2D)
	
	for slot : Marker2D in slots:
		ChooseRoom(slot)

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("rotate")):
		_ready()

		
func ChooseRoom(marker : Marker2D):
	var files = Array(DirAccess.get_files_at(RoomDirectory))
	files.shuffle()
	var scene = load(RoomDirectory + files.pick_random()).instantiate()
	marker.add_child(scene)
	return
