extends ColorRect
@onready var stars: TextureRect = $Stars
@onready var nebula: TextureRect = $Nebula

@export var useNeb = false

func _ready():
	z_index = -500
	SetScrollSpeed(0)
		#

func SetScrollSpeed(amount : float):
	stars.material.set_shader_parameter("speed", amount)
	

func StopScroll():
	stars.material.set_shader_parameter("speed", 0)

func ShipScroll():
	stars.material.set_shader_parameter("speed", clamp(float(GlobalPlayerInfo.ThePlayerShip.GetSpeed())/5.0, 0.1, 20))
	if(useNeb):
		nebula.show()
		nebula.material.set_shader_parameter("speed", clamp(float(GlobalPlayerInfo.ThePlayerShip.GetSpeed())/5.0, 0.1, 20)/10.0)
	else:
		nebula.hide()
