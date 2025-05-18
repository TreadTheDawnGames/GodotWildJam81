extends Sprite2D
class_name RoomChooser

### Marker2D array
var slots : Array
const CREWMATE = preload("res://Scenes/Objects/crewmate.tscn")
static var RoomDirectory : String = "res://Scenes/ShipTilemapScenes/Rooms/"

@export var shipParts : Array[PackedScene] = []
static var ShipParts : Array[PackedScene] = []

func _ready() -> void:
	slots = get_children().filter(func(a): return a is ShopSlot)
	ShipParts = shipParts
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
	var scene : ShipRoom = ShipParts.pick_random().instantiate() as ShipRoom
	if(randi()%2==0):
		scene.includedCrew=CREWMATE.instantiate()
		scene.includedCrew.processStates = false
	return scene
