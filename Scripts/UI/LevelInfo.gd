class_name  LevelInfo

func _init(timeToReach: int, reputation: int, spaceDust: int, pirates: int, asteroidDensity: int, asteroidRoute: bool = false, nebula: bool = false, levelPosition: Vector2 = IdealStartPos):
	TimeToReach = timeToReach
	Reputation = reputation
	SpaceDust = spaceDust
	Pirates = pirates
	AsteroidDensity = asteroidDensity
	AsteroidRoute = asteroidRoute
	Nebula = nebula
	moneyAmt = round(reputation * 0.2)
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
var moneyAmt : int
var FinalLevel : bool = false

static func generateRandomLevel(nebula: bool = false, levelPosition: Vector2 = IdealStartPos, canBeAsteroidRoute: bool = false, dumbMode: bool = false) -> LevelInfo:
	return LevelInfo.new(getRandomTimeToReach(levelPosition), getRandomReputation(levelPosition), getRandomSpaceDust(), getRandomPirateChance(levelPosition), getRandomAsteroidDensity(levelPosition, canBeAsteroidRoute, dumbMode), nebula)

func makePopupText(timeToReach: int, reputation: int, spaceDust: int, pirates: int, asteroidDensity: int, nebula: bool = false) -> String:
	var popupText: String = ""
		#https://forum.godotengine.org/t/how-to-show-on-a-label-how-much-time-from-a-timer-is-left/13594
	var timeString = "%d:%02d" % [floor(timeToReach / 60.0), int(timeToReach) % 60] +"\n"
	popupText += "Time to Travel: " + timeString
	var reputationAmt = str(reputation)
	popupText += "Reputation: " + reputationAmt + "\n"
	popupText += "Money: $" + str(moneyAmt) + "\n"
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
	var minValue = 45
	var maxValue = 120
	var distanceFactor = remap(distance, 0.0, 1000.0, minValue, maxValue)
	return clamp(distanceFactor, minValue, maxValue)
	#return randi_range(180, 300) # 3 to 5 minValueutes is aight I think

static func getRandomReputation(levelPosition: Vector2 = IdealStartPos) -> int:
	var distance = levelPosition.distance_to(IdealStartPos)
	var minValue = 150
	var maxValue = 350
	var distanceFactor = remap(distance, 0.0, 1000.0, minValue, maxValue)
	return clamp(distanceFactor, minValue, maxValue)
	#return randi_range(minReputation, maxValueReputation)

static func getRandomPirateChance(_levelPosition: Vector2 = IdealStartPos) -> int:
	#var distance = levelPosition.distance_to(IdealStartPos)
	#var minValue = 0
	#var maxValue = randi_range(40, 70)
	#var distanceFactor = remap(distance, 0.0, 1000.0, minValue, maxValue)
	#return clamp(distanceFactor, minValue, maxValue)
	return randi_range(0, 100) 
	
static func getRandomAsteroidDensity(levelPosition: Vector2 = IdealStartPos, canBeAsteroidRoute: bool = false, dumbMode: bool = false) -> int:
	var distance = levelPosition.distance_to(IdealStartPos)
	var minValue = 0
	var maxValue = 60
	if canBeAsteroidRoute and dumbMode:
		minValue = 100
		maxValue = 100
	elif dumbMode:
		minValue = 60
		maxValue = 100
	elif canBeAsteroidRoute:
		minValue = 60
		maxValue = 80
	var distanceFactor = remap(distance, 0.0, 1000.0, minValue, maxValue)
	return clamp(distanceFactor, minValue, maxValue)

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

func _to_string() -> String:
	return makePopupText(TimeToReach, Reputation, SpaceDust, Pirates, AsteroidDensity, Nebula)
