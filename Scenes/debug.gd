extends Node2D

const shopScene = preload("res://Scenes/ShipBuilder/ship_builder.tscn")

func _ready():
	get_node("PlayerShip").EnterStorage()

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("DEBUG-SpawnPlayerShip")):
		GlobalPlayerInfo.ShipExitStorage(global_position )
		print("Spawning ship")
	if(Input.is_action_just_pressed("DEBUG-openShop")):
		add_child(shopScene.instantiate())
