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
@onready var debug: Button = $Debug


func _ready() -> void:
	debug.pressed.connect(TakeDamage.bind(1))

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
	var text: RichTextLabel = $RichTextLabel
	text.text = str(hitpoints)
	
	area_entered.connect(HitSomething)
	return


func _process(delta: float) -> void:
	global_position.x -= speed * delta * (GlobalPlayerInfo.ThePlayerShip.GetSpeed() / 2)
	if(global_position.x < -50):
		queue_free()
		
func TakeDamage(amount : int):
	hitpoints-=amount
	var text: RichTextLabel = $RichTextLabel
	text.text = str(hitpoints)
	if(hitpoints<=0):
		if(isSmall):
			queue_free()
		else:
			for i in 2:
				var ast = ASTEROID.instantiate()
				ast.isSmall = true
				ast.position = Vector2(randf_range(-25, 25), randf_range(-25,25)) + global_position
				get_parent().add_child(ast)
				queue_free()
#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#return
func HitSomething(area : Area2D):
	print("hit")
	if area.owner is ConnectionCell:
		print("hit con cell")
		var cell : ConnectionCell = area.owner
		if(!area.owner.Map):
			print("no map")
			return
		if(area.owner.Map.Faction == ShipRoom.ShipFaction.Player):
			print("hit player")
			if(area.owner.Map is PlayerShip):
				print("hit the ship")
				var hitShip : PlayerShip = cell.Map
				for room in hitShip.SubMaps:
					print("submapping")
					if(room.positionIndexedChildren.has(cell.myCoords)):
						print("hit room: ", room)
						if(room.DamageRoom(1)):
							hitShip.SubMaps.erase(room)
						queue_free()
					else:
						print(room, " does not have ", cell.myCoords)
		else:
			print("not a valid faction")
	else:
		print("owner is not connection cellwwwwwwdaa")
