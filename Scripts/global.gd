extends Node


func mouse_position_to_local(input: InputEventMouse, camera: Camera2D) -> Vector2:
	var vp_size = Vector2.ZERO
	
	# Get the top left corner of the viewport if needed
	if camera.anchor_mode == Camera2D.ANCHOR_MODE_DRAG_CENTER:
		vp_size = get_viewport().get_visible_rect().size
	
	return camera.position - vp_size/2 + input.position