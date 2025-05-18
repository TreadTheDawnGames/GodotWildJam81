extends Area2D
class_name Asteroid

var isSmall : bool = false
@onready var sprite: Sprite2D = $Sprite2D

@export var LargeAsteroids : Array[Texture2D]
@export var SmallAsteroids : Array[Texture2D]
@onready var lShape: CollisionShape2D = $LShape
@onready var sShape: CollisionShape2D = $SShape

const ASTEROID = preload("res://Scenes/LevelScenes/asteroid.tscn")

var hitpoints : int
var speed : int = 50

func _ready() -> void:
	sprite = get_node("Sprite2D")
	if(isSmall):
		sprite.texture = SmallAsteroids.pick_random()
		hitpoints = 3
		lShape.disabled = true
	else:
		sprite.texture = LargeAsteroids.pick_random()
		hitpoints = 5
		sShape.disabled = true
		
	speed =  randi_range(25,75)
	#apply_force(Vector2.LEFT * randi_range(1000,7500))
	#constant_force = Vector2.LEFT * randi_range(10,75)
	area_entered.connect(HitSomething)
	return


func _process(delta: float) -> void:
	global_position.x -= speed * delta #* float(GlobalPlayerInfo.ThePlayerShip.GetSpeed() / 2.0)
	if(global_position.x < -50):
		queue_free()
		
func TakeDamage(amount : int):
	hitpoints-=amount
	if(hitpoints<=0):
		if(isSmall):
			queue_free()
		else:
			for i in 2:
				var ast = ASTEROID.instantiate()
				ast.isSmall = true
				ast.position = Vector2(randf_range(-25, 25), randf_range(-25,25)) + global_position
				get_parent().add_child.call_deferred(ast)
				queue_free()
#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#return
func HitSomething(area : Area2D):
	if area.owner is ConnectionCell:
		var cell : ConnectionCell = area.owner
		if(!area.owner.Map):
			return
		if(area.owner.Map.Faction == ShipRoom.ShipFaction.Player):
			if(area.owner.Map is ShipRoom):
				var hitShip : ShipRoom = cell.get_parent()
				hitShip.DamageRoom(1)
				$CrashIntoAsteroid.play()


func _on_crash_into_asteroid_finished() -> void:
	queue_free()
