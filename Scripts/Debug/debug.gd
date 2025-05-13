extends Node2D
class_name DebugNode

var shapesToDraw : Array[DebugShape]

func Draw(shape : DebugShape):
	shapesToDraw.append(shape)
	queue_redraw()
	return

func _draw():
	for shape : DebugShape in shapesToDraw:
		match(shape.Shape):
			DebugShape.ShapeType.Line:
				draw_line(shape.ShapeArgs[0], shape.ShapeArgs[1], shape.MyColor, shape.ShapeArgs[2], shape.ShapeArgs[3])
				pass
			DebugShape.ShapeType.Rect:
				draw_rect(shape.ShapeArgs[0], shape.MyColor, shape.ShapeArgs[1], shape.ShapeArgs[2], shape.ShapeArgs[3])
				pass
			DebugShape.ShapeType.Circle:
				draw_circle(shape.ShapeArgs[0], shape.ShapeArgs[1], shape.MyColor, shape.ShapeArgs[2], shape.ShapeArgs[3], shape.ShapeArgs[4])
				pass
	return
	
	



class DebugShape:
	enum ShapeType {Line, Rect, Circle}
	var Shape : ShapeType
	var ShapeArgs : Array
	var MyColor : Color
	func _init(shape : ShapeType, shapeArgs : Array, color : Color):
		Shape = shape
		ShapeArgs = shapeArgs
		MyColor = color
		return
	
