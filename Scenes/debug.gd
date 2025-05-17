extends Node2D

const shopScene = preload("res://Scenes/ShipBuilder/shipyard.tscn")
const LEVEL = preload("res://Scenes/LevelScenes/level.tscn")

var DEBUGcurrentLevel

func _ready():
	get_node("PlayerShip").EnterStorage()

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("DEBUG-SpawnPlayerShip")):
		GlobalPlayerInfo.ShipExitStorage(global_position )
		print("Spawning ship")
	if(Input.is_action_just_pressed("DEBUG-openShop")):
		add_child(shopScene.instantiate())
	if(Input.is_action_just_pressed("DEBUG-AddMoney")):
		GlobalPlayerInfo.AddMoney(20)
	if(Input.is_action_just_pressed("DEBUG-RandomLevel")):
		if(DEBUGcurrentLevel):
			GlobalPlayerInfo.UnsetActiveLevel()
			DEBUGcurrentLevel.queue_free()
		DEBUGcurrentLevel = LEVEL.instantiate()
		DEBUGcurrentLevel.info = LevelInfo.generateRandomLevel(randi()%2==0)
		add_child(DEBUGcurrentLevel)
		GlobalPlayerInfo.SetActiveLevel(DEBUGcurrentLevel)
		
	if(Input.is_action_just_pressed("DEBUG-CloseLevel")):
		GlobalPlayerInfo.UnsetActiveLevel()
		if(DEBUGcurrentLevel):
			DEBUGcurrentLevel.queue_free()
		Background.StopScroll()
