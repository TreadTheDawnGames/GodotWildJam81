extends Node2D
class_name Level

var info : LevelInfo
@onready var asteroidSpawner: Node2D = $AsteroidSpawner
@onready var pirate_spawner: PirateBuilder = $PirateSpawner
@onready var pirateTimer: Timer = $PirateSpawner/pirateTimer
var levelTimerMax : float = 500
@onready var levelTimerLeft: float #Timer = $LevelTimer
@onready var planet_sprite: Sprite2D = $planetSprite

@export var planets : Array[Texture2D]

var complete : bool = false

signal LevelComplete


func _ready():
	asteroidSpawner = get_node("AsteroidSpawner")
	pirate_spawner = get_node("PirateSpawner")
	pirateTimer = get_node("PirateSpawner/pirateTimer")
	levelTimerLeft = info.TimeToReach
	planet_sprite = get_node("planetSprite")
	planet_sprite.texture = planets.pick_random()
	
	if(info.Nebula):
		info.SpaceDust *=2
	
	Background.useNeb = info.Nebula if info else false
	var playerSpeed : float = float(GlobalPlayerInfo.ThePlayerShip.GetSpeed()) if GlobalPlayerInfo.ThePlayerShip else 100.0
	var Dust : CPUParticles2D = CPUParticles2D.new()
	@warning_ignore("integer_division")
	Dust.amount = clamp(250 * (info.SpaceDust * int(playerSpeed))/100, 1, 99999) if info else 100
	Dust.lifetime = 15.0 * playerSpeed
	Dust.preprocess = 15.0* playerSpeed
	Dust.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	Dust.emission_rect_extents = Vector2(1.0,325.0)
	Dust.spread = 0.0
	Dust.gravity = Vector2(-clamp(float(playerSpeed)/5.0, 0.1, 20)*10,0)
	Dust.initial_velocity_min = Dust.gravity.length()
	Dust.color = Color.RED
	#Dust.radial_accel_max = 8.0
	#Dust.radial_accel_max = -8.0
	#Dust.tangential_accel_max = 5.0
	#Dust.tangential_accel_min = -5.0
	Dust.scale_amount_max = 3.0
	Dust.hue_variation_max = 1.0
	
	Dust.global_position = Vector2(1160, 325)
	add_child(Dust)
	Background.ShipScroll()
	asteroidSpawner.SetDensity(info.AsteroidDensity if info else 100)
	pirateTimer.timeout.connect(TrySpawnPirate)
	pirateTimer.autostart = true
	
	var pirateOutTimer = get_tree().create_timer(info.TimeToReach if info else 30 - 20)
	pirateOutTimer.timeout.connect(pirate_spawner.PirateMoveInOut.bind(true))

	var planetInViewTimer = get_tree().create_timer(info.TimeToReach if info else 50 - 40)
	planetInViewTimer.timeout.connect(planet_sprite.Move)

func TrySpawnPirate():
	var rand = randi()%100 +1
	if(rand <= info.Pirates):
		pirate_spawner.show()
		pirate_spawner.SpawnPirate(randi()%3+1)
		pirateTimer.timeout.disconnect(TrySpawnPirate)
	else:
		pirate_spawner.hide()
		pirateTimer.start()
		
	return

func _process(delta: float) -> void:
	levelTimerLeft -= delta * (GlobalPlayerInfo.ThePlayerShip.GetSpeed()/2)
	if(levelTimerLeft <= 0):
		TransitionOutOfLevel()
		pass
	
	return

func TransitionOutOfLevel():
	ExitWithoutShop()
	LevelComplete.emit()
	return

func ExitWithoutShop():
	Background.StopScroll()
	GlobalPlayerInfo.AddMoney(info.moneyAmt)
	GlobalPlayerInfo.AddRep(info.Reputation)
	GlobalPlayerInfo.TotalTime += info.TimeToReach - levelTimerLeft
	
	complete = true
	queue_free()
	return
