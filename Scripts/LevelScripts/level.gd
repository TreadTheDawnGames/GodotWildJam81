extends Node2D
class_name Level

var info : LevelInfo
@onready var asteroidSpawner: Node2D = $AsteroidSpawner
@onready var pirate_spawner: PirateBuilder = $PirateSpawner
@onready var pirateTimer: Timer = $PirateSpawner/pirateTimer
@onready var level_timer: Timer = $LevelTimer
var complete : bool = false

signal LevelComplete

func _ready():
	asteroidSpawner = get_node("AsteroidSpawner")
	pirate_spawner = get_node("PirateSpawner")
	pirateTimer = get_node("PirateSpawner/pirateTimer")
	level_timer = get_node("LevelTimer")
	level_timer.wait_time = info.TimeToReach
	level_timer.start()
	level_timer.timeout.connect(TransitionOutOfLevel)
	
	Background.useNeb = info.Nebula
	var playerSpeed : float = float(GlobalPlayerInfo.ThePlayerShip.GetSpeed())
	var Dust : CPUParticles2D = CPUParticles2D.new()
	@warning_ignore("integer_division")
	Dust.amount = 250 * (info.SpaceDust * int(playerSpeed))/100
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
	asteroidSpawner.SetDensity(info.AsteroidDensity)
	pirateTimer.timeout.connect(TrySpawnPirate)
	pirateTimer.autostart = true
	print(info)
	
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

func TransitionOutOfLevel():
	Background.StopScroll()
	GlobalPlayerInfo.AddMoney(info.moneyAmt)
	GlobalPlayerInfo.AddRep(info.Reputation)
	complete = true
	queue_free()
	LevelComplete.emit()
	return
