class_name  LevelInfo

func _init(timeToReach: int, reputation: int, spaceDust: int, pirates: int, asteroidDensity: int, asteroidRoute: bool = false, nebula: bool = false, levelPosition: Vector2 = IdealStartPos):
	TimeToReach = timeToReach
	Reputation = reputation
	SpaceDust = spaceDust
	Pirates = pirates
	AsteroidDensity = asteroidDensity
	AsteroidRoute = asteroidRoute
	Nebula = nebula
	
	var distanceToStart: float = levelPosition.distance_squared_to(IdealStartPos)
	DistanceFactor = remap(distanceToStart, 0.0, 1000.0, 0.0, 1.5)
	
	return 

const IdealStartPos := Vector2( 0, 300 )
		  
const minReputation = 50
const maxReputation = 300
const spaceDustLowBias = 0.8
var TimeToReach: int 
var Reputation: int
var SpaceDust: int
var Pirates: int
var AsteroidDensity: int
var AsteroidRoute: bool
var Nebula: bool
var DistanceFactor: Variant

static func generateRandomLevel(nebula: bool = false, levelPosition: Vector2 = IdealStartPos, canBeAsteroidRoute: bool = false, dumbMode: bool = false) -> LevelInfo:
	return LevelInfo.new(getRandomTimeToReach(levelPosition), getRandomReputation(levelPosition), getRandomSpaceDust(), getRandomPirateChance(levelPosition), getRandomAsteroidDensity(levelPosition, canBeAsteroidRoute, dumbMode), nebula)

func makePopupText(timeToReach: int, reputation: int, spaceDust: int, pirates: int, asteroidDensity: int, nebula: bool = false) -> String:
	var popupText: String = ""
	var timeToTravel = str(timeToReach)
	popupText += "Time to Travel: " + timeToTravel + " Seconds\n"
	var reputationAmt = str(reputation)
	popupText += "Reputation: " + reputationAmt + "\n"
	var moneyAmt = str(round(reputation * 0.2))
	popupText += "Money: $" + moneyAmt + "\n"
	var spaceDustText = str(spaceDust)
	popupText += "Space Dust: " + spaceDustText + "%\n"
	var pirateChance = str(pirates)
	popupText += "Chance of Pirates: " + pirateChance + "%\n"
	var asteroidText = str(asteroidDensity)
	popupText += "Asteroid Density: " + asteroidText + "%\n"
	if nebula:
		popupText += "BEWARE Nebula"
	
	return popupText

static func getRandomTimeToReach(levelPosition: Vector2 = IdealStartPos) -> int:
	var distance = levelPosition.distance_to(IdealStartPos)
	var min = 180
	var max = 300
	var distanceFactor = remap(distance, 0.0, 1000.0, min, max)
	return clamp(distanceFactor, min, max)
	#return randi_range(180, 300) # 3 to 5 minutes is aight I think

static func getRandomReputation(levelPosition: Vector2 = IdealStartPos) -> int:
	var distance = levelPosition.distance_to(IdealStartPos)
	var min = 150
	var max = 350
	var distanceFactor = remap(distance, 0.0, 1000.0, min, max)
	return clamp(distanceFactor, min, max)
	#return randi_range(minReputation, maxReputation)

static func getRandomPirateChance(levelPosition: Vector2 = IdealStartPos) -> int:
	#var distance = levelPosition.distance_to(IdealStartPos)
	#var min = 0
	#var max = randi_range(40, 70)
	#var distanceFactor = remap(distance, 0.0, 1000.0, min, max)
	#return clamp(distanceFactor, min, max)
	return randi_range(0, 100) 
	
static func getRandomAsteroidDensity(levelPosition: Vector2 = IdealStartPos, canBeAsteroidRoute: bool = false, dumbMode: bool = false) -> int:
	var distance = levelPosition.distance_to(IdealStartPos)
	var min = 0
	var max = 60
	if canBeAsteroidRoute and dumbMode:
		min = 100
		max = 100
	elif dumbMode:
		min = 60
		max = 100
	elif canBeAsteroidRoute:
		min = 60
		max = 80
	var distanceFactor = remap(distance, 0.0, 1000.0, min, max)
	return clamp(distanceFactor, min, max)

static func getRandomSpaceDust() -> int:
	return randi_range(0, 100)

static func calculateDifficulty(time: float, reputation: int, pirateChance: int, spaceDust: int, distanceFactor: float = 1.0) -> int: # camelCase
	var difficulty = 0

	difficulty += int(remap(time, 300.0, 180.0, 0, 30))
	difficulty += int(remap(int(reputation), int(maxReputation), int(minReputation), 0, 30))
	difficulty += int(pirateChance * 0.3)
	difficulty += int(spaceDust * 0.1)
	difficulty += int(distanceFactor * 20)
	#giving difficulty an arbitrary number for now, can't think of a good grading system atm
	return clamp(difficulty, 0, 100)
