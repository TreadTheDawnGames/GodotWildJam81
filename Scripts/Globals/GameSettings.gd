extends Node

# Well this was fairly easy to do, I expected myself to struggle with this lol
# thx to this YT-Vid https://www.youtube.com/watch?v=tfqJjDw0o7Y

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = 'user://settings.ini'

var DUMBMODE: bool
var SCREENSHAKE: bool

func _init(screenShake: bool = true, dumbMode: bool = false) -> void:
	DUMBMODE = dumbMode
	SCREENSHAKE = screenShake

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("Volume", "Master", 1.0)
		config.set_value("Volume", "Music", 1.0)
		config.set_value("Volume", "SFX", 1.0)
		
		config.set_value("Video", "ScreenShake", true)
		
		config.set_value("Gameplay", "DumbMode", false)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func saveValue(category: String, key: String, value) -> void:
	config.set_value(category, key, value)
	config.save(SETTINGS_FILE_PATH)

func loadConfigValues() -> Dictionary:
	var settings = {}
	var sectionsArray = config.get_sections()
	for section in sectionsArray:
		var sectionKeys = config.get_section_keys(section)
		for key in sectionKeys:
			settings[ key ] = config.get_value(section, key)
	return settings
