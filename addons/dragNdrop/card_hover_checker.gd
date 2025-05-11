extends Node2D

func _process(_delta : float):
	#foreach card in tdcarddata.hoveredcards
		#if card is hovered and mouse is not contained
			#card.hovered = false
	for card : TDCard in TDCard.hoveredCards.filter(func(a):
		if(not is_instance_valid(a)):
			return false
		return a._hovered):
			
		if(not is_instance_valid(card)):
			continue
		var space_state = get_world_2d().direct_space_state
		var params = PhysicsPointQueryParameters2D.new() 
		params.position = get_global_mouse_position()
		params.collide_with_areas = true
		var out = space_state.intersect_point(params)
		if(out.size() == 0):
			card.Unhovered()
			return
			
		#for d in out:
			#if(d["rid"].get_id() == card.get_rid().get_id()):
				#return
			#card._hovered = false
	return
