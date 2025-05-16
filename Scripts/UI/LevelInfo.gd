class_name  LevelInfo

func _init(timeToReach: int, reputation: int, spaceDust: int, pirates: int, asteroidDensity: int, nebula: bool = false):
	TimeToReach = timeToReach
	Reputation = reputation
	SpaceDust = spaceDust
	Pirates = pirates
	AsteroidDensity = asteroidDensity
	Nebula = nebula
	return 

const idealStartPos := Vector2( 0, 300 )
var distanceToStart: float
var distanceFactor = remap(distanceToStart, 0.0, 1000.0, 0.0, 1.5)
		  
const minReputation = 50
const maxReputation = 300
const spaceDustLowBias = 0.8
var TimeToReach: int 
var Reputation: int
var SpaceDust: int
var Pirates: int
var AsteroidDensity: int
var Nebula: bool

static func generateRandomLevel(nebula = false) -> LevelInfo:
	return LevelInfo.new(getRandomTimeToReach(), getRandomReputation(), getRandomSpaceDust(), getRandomPirateChance(), getRandomAsteroidDensity(), nebula)

func makePopupText(timeToReach: int, reputation: int, spaceDust: int, pirates: int, asteroidDensity: int, nebula: bool = false) -> String:
	var popupText: String
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

static func getRandomTimeToReach() -> int:
	return randi_range(180.0, 300.0) # 3 to 5 minutes is aight I think

static func getRandomReputation() -> int:
	return randi_range(minReputation, maxReputation)

static func getRandomPirateChance() -> int:
	return randi_range(0.0, 100.0) 
	
static func getRandomAsteroidDensity() -> int:
	return randi_range(0.0, 60.0)

static func getRandomSpaceDust() -> int:
	return randi_range(0.0, 100.0)

static func calculateDifficulty(time: float, reputation: int, pirateChance: int, spaceDust: int, distanceFactor: float = 1.0) -> int: # camelCase
	var difficulty = 0

	difficulty += int(remap(time, 300.0, 180.0, 0, 30))
	difficulty += int(remap(float(reputation), float(maxReputation), float(minReputation), 0, 30))
	difficulty += int(pirateChance * 0.3)
	difficulty += int(spaceDust * 0.1)
	difficulty += int(distanceFactor * 20)
	#giving difficulty an arbitrary number for now, can't think of a good grading system atm
	return clamp(difficulty, 0, 100)
