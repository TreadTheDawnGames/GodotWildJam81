extends Cell
class_name DissallowedConnectionCell
func AssignLoadOrder():
	loadOrder = 2
func Init():
	super.Init()
	var neighbors = GetNeighbors()
	for neighbor in neighbors:
		var neighborCell : Cell = Map.GetChildByCoords(neighbor)
		if(neighborCell is ConnectionCell):
			match(myCoords - neighbor):
				Vector2i.RIGHT:
					neighborCell.RemoveConnection(neighborCell.Direction.East)
					print("Removed East")
				Vector2i.LEFT:
					neighborCell.RemoveConnection(neighborCell.Direction.West)
					print("Removed West")
				Vector2i.UP:
					neighborCell.RemoveConnection(neighborCell.Direction.North)
					print("Removed North")
				Vector2i.DOWN:
					neighborCell.RemoveConnection(neighborCell.Direction.South)
					print("Removed South")
					
	Map.RemoveChildByCoords(myCoords)
	queue_free()
