extends CanvasLayer

func _make_custom_tooltip(for_text):
	var label = Label.new()
	label.text = for_text
	return label
