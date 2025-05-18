extends Node

func _on_space_map_bgm_finished() -> void:
	%SpaceMapBGM.play()

func _on_level_bgm_finished() -> void:
	%LevelBGM.play()

func _on_main_menu_bgm_finished() -> void:
	%MainMenuBGM.play()

func stopAllMusic() -> void:
	%MainMenuBGM.stop()
	%SpaceMapBGM.stop()
	%LevelBGM.stop()
