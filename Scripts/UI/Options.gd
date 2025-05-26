extends Control
class_name OptionsMenu

signal QuitOptions

func _ready() -> void:
	var gameSettings = GameSettings.loadConfigValues()
	%DumbModeToggle.button_pressed = gameSettings.DumbMode
	%ScreenShakeToggle.button_pressed = gameSettings.ScreenShake
	%SFXVolumeSlider.value = gameSettings.SFX
	%MusicVolumeSlider.value = gameSettings.Music
	%VolumeSlider.value = gameSettings.Master
	%ShowTutsToggle.button_pressed = GlobalPlayerInfo.hideTutorials

func _on_quit_options_button_pressed() -> void:
	QuitOptions.emit()

func _on_screen_shake_toggle_toggled(toggled_on: bool) -> void:
	GameSettings.saveValue("Video", "ScreenShake", toggled_on)

func _on_dumb_mode_toggle_toggled(toggled_on: bool) -> void:
	GameSettings.saveValue("Gameplay", "DumbMode", toggled_on)

func _on_sfx_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GameSettings.saveValue("Volume", "SFX", %SFXVolumeSlider.value)

func _on_music_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GameSettings.saveValue("Volume", "Music", %MusicVolumeSlider.value)

func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GameSettings.saveValue("Volume", "Master", %VolumeSlider.value)


func _on_show_tuts_toggle_toggled(toggled_on: bool) -> void:
	GlobalPlayerInfo.hideTutorials = !toggled_on
	pass # Replace with function body.
