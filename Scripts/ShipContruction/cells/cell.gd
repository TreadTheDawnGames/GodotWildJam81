extends Node2D
class_name Cell
var myCoords : Vector2i 
var Map : ShipRoom
var loadOrder : int = 0

func Init():
	Map = get_parent()
	myCoords = Map.local_to_map(Map.to_local(global_position))
	return

func GetNeighbors() -> Array[Vector2i]:
	return Map.get_surrounding_cells(myCoords)

func AssignLoadOrder():
	loadOrder = 0
