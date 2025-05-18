extends ShipBuilder
class_name PirateBuilder

var pirate : PirateShip

var difficulty : int = 1

var completeness : int
@export var maxLife : int = 20
@export var minLife : int = 12

func _ready():
	return

func _process(_delta : float):
	return

func SpawnPirate(dif : int):
	difficulty = dif
	pirate = get_node("PirateShip")
	for i in difficulty:
		AssemblePirate(i)
	pirate.hitpoints = randi_range(minLife, maxLife)*difficulty
 
	return
	
	

func AssemblePirate(posi : int):
	var roomToAdd : ShipRoom = RoomChooser.GetRandomAvailableRoom()
	add_child(roomToAdd)
	#                        https://forum.godotengine.org/t/what-is-the-best-way-to-generate-a-random-boolean-i-e-0-or-1/20363
	var LR = Vector2(32,0) * ((randi() & 1))
	var UD = Vector2(0,32) * ((randi() & 1))
	
	match(posi):
		0:
			roomToAdd.global_position = pirate.global_position - Vector2(0, roomToAdd.sprite.texture.get_size().y )+ LR
			pass
		1:
			roomToAdd.global_position = pirate.global_position - Vector2(roomToAdd.sprite.texture.get_width(), 0)+UD
			pass
		2:
			roomToAdd.global_position = pirate.global_position - Vector2(0, -(pirate.sprite.texture.get_height() ))+ LR
			pass
				
	
	playerShip = pirate
	
	#https://godotforums.org/d/35537-looking-for-a-way-to-signal-a-funtion-to-be-called-on-the-next-frame/4
	get_tree().create_timer(0.1).timeout.connect(DoConnection.bind(roomToAdd, posi))
	
	return

func DoConnection(roomToAdd : ShipRoom, posi : int):
	
	if(playerShip.AbleToConnectPiece(roomToAdd, playerShip.local_to_map(playerShip.to_local(roomToAdd.global_position)))):
		playerShip.DoCombine(roomToAdd)
		roomToAdd.sprite.modulate = Color(1,0.5,0.5)
		addingRoomCell = null
		addingRoom = null
		completeness += 1
		AttemptFlip()
	else:
		roomToAdd.queue_free()
		AssemblePirate(posi)

func AttemptFlip():
	if(completeness == difficulty):
		playerShip.scale.x *=-1
		playerShip.editing = false
