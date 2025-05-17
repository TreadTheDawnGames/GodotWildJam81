extends Node2D
class_name AsteroidSpawner

var Density : int

var asteroidScene = preload("res://Scenes/LevelScenes/asteroid.tscn")
@onready var spawnTimer: Timer = $Timer

var canSpawn : bool = true

#func _init(density : int) -> void:
	#Density = density
	#spawnTimer.timeout.connect(func(): canSpawn = true)
	#return

func _ready() -> void:
	Density = 60
	spawnTimer.timeout.connect(AttemptToSpawn)
	spawnTimer.start(0)
func SpawnAsteroid():
	var asteroid : Asteroid = asteroidScene.instantiate()
	asteroid.isSmall = randi() % 3 == 0
	add_child(asteroid)
	asteroid.position = Vector2(1200, randf_range(0,650))
	
	return

func AttemptToSpawn():
	spawnTimer.start(1.0 / (float(Density) / 40.0))# + GlobalPlayerInfo.ThePlayerShip.GetSpeed()))
	if(randi()%100+1 < Density):
		SpawnAsteroid()

func SetDensity(density : int):
		Density = density
