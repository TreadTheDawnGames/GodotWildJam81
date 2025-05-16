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
				Vector2i.LEFT:
					neighborCell.RemoveConnection(neighborCell.Direction.West)
				Vector2i.UP:
					neighborCell.RemoveConnection(neighborCell.Direction.North)
				Vector2i.DOWN:
					neighborCell.RemoveConnection(neighborCell.Direction.South)
					
	Map.RemoveChildByCoords(myCoords)
	Map.set_cell(myCoords, -1)
	queue_free()
