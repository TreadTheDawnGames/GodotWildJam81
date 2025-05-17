extends Sprite2D
class_name RoomChooser

### Marker2D array
var slots : Array

static var RoomDirectory : String = "res://Scenes/ShipTilemapScenes/Rooms/"

func _ready() -> void:
	slots = get_children().filter(func(a): return a is ShopSlot)
	
	for slot : ShopSlot in slots:
		ChooseRoom(slot)

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("rotate")):
		_ready()

		
func ChooseRoom(marker : ShopSlot):
	var scene = GetRandomAvailableRoom()
	add_child(scene)
	scene.position = marker.position - scene.sprite.texture.get_size()/2
	scene.LocationMarker = marker
	marker.setPrice(scene.Price)
	return

static func GetRandomAvailableRoom() -> ShipRoom:
	var files = Array(DirAccess.get_files_at(RoomDirectory))
	files.shuffle()
	var scene : ShipRoom = load(RoomDirectory + files.pick_random()).instantiate() as ShipRoom
	return scene
