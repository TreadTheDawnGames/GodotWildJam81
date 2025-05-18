extends Sprite2D
class_name RoomChooser

### Marker2D array
var slots : Array
const CREWMATE = preload("res://Scenes/Objects/crewmate.tscn")
static var RoomDirectory : String = "res://Scenes/ShipTilemapScenes/Rooms/"

@export var shipParts : Array[PackedScene] = []
static var ShipParts : Array[PackedScene] = []

@export var laserShipParts : Array[PackedScene] = []
static var LaserShipParts : Array[PackedScene] = []

func _ready() -> void:
	slots = get_children().filter(func(a): return a is ShopSlot)
	ShipParts = shipParts
	LaserShipParts = laserShipParts
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

static func GetRandomAvailableRoom(filterForLasers: bool = false) -> ShipRoom:
	var files = Array(DirAccess.get_files_at(RoomDirectory))
	files.shuffle()
	var scene : ShipRoom 
	if(filterForLasers):
		scene = LaserShipParts.pick_random().instantiate() as ShipRoom #ShipParts.filter(func(a:PackedScene): return a.resource_name.ends_with("l")).pick_random().instantiate() as ShipRoom
		#.name.ends_with("l")).pick_random().instantiate() as ShipRoom
		
	else:
		scene = ShipParts.pick_random().instantiate() as ShipRoom
	if(randi()%5==0):
		scene.includedCrew=CREWMATE.instantiate()
		scene.includedCrew.processStates = false
	return scene
