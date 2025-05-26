extends HSlider

@export var busName: String

var busIndex: int

func _ready() -> void:
	busIndex = AudioServer.get_bus_index(busName)
	value_changed.connect(onValueChanged)
	value = db_to_linear(
		AudioServer.get_bus_volume_db(busIndex)
	)

func onValueChanged(_myValue: float) -> void:
	AudioServer.set_bus_volume_db(
		busIndex,
		linear_to_db(value)
	)
