extends Control
class_name MainMenu

signal StartClicked
signal OptionsClicked
signal QuitGame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_start_game_button_pressed() -> void:
	StartClicked.emit()

func _on_options_button_pressed() -> void:
	OptionsClicked.emit()

func _on_quit_game_button_pressed() -> void:
	QuitGame.emit()
