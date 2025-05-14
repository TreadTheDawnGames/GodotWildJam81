extends Cell
class_name GuarenteedConnectionCell

func AssignLoadOrder():
	loadOrder = 1

func Init():
	super.Init()
	var neighbors = GetNeighbors()
	for neighbor in neighbors:
		var neighborCell : Cell = Map.GetChildByCoords(neighbor)
		if(neighborCell is ConnectionCell):
			match(myCoords - neighbor):
				Vector2i.LEFT:
					neighborCell.AddConnection(neighborCell.Direction.West)
				Vector2i.RIGHT:
					neighborCell.AddConnection(neighborCell.Direction.East)
				Vector2i.DOWN:
					neighborCell.AddConnection(neighborCell.Direction.South)
				Vector2i.UP:
					neighborCell.AddConnection(neighborCell.Direction.North)
	Map.RemoveChildByCoords(myCoords)
	queue_free()
