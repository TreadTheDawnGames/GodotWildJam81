extends Resource

class_name PitStopPopupContent

@export_category('Information')
@export var timeToReach: int = getRandomTimeToReach()
@export var popupName: String
@export var chanceOfPirates: int = getRandomPirateChance()
@export var spaceDustAmt: int = getRandomSpaceDust()
@export var reputationAmt: int = getRandomReputation()
@export var difficulty: int = calculateDifficulty(timeToReach, reputationAmt, chanceOfPirates, spaceDustAmt, distanceFactor)

@export_category('Bonus Content')

const idealStartPos := Vector2( 0, 300 )
var distanceToStart = pointOnPointMap.global_position.distance_to(idealStartPos)
var distanceFactor = remap(distanceToStart, 0.0, 1000.0, 0.0, 1.5)
		  
const minReputation = 50
const maxReputation = 300
const spaceDustLowBias = 0.8

func getRandomTimeToReach() -> float:
	return randf_range(180.0, 300.0) # 3 to 5 minutes is aight I think

func getRandomReputation() -> int:
	return randi_range(minReputation, maxReputation)

func getRandomPirateChance() -> float:
	return randf_range(0.0, 100.0) 

func getRandomSpaceDust() -> float:
	var rand_val = randf()
	return pow(rand_val, 1.0 / spaceDustLowBias) * 100.0

func calculateDifficulty(time: float, reputation: int, pirateChance: float, spaceDust: float, distanceFactor: float = 1.0) -> int: # camelCase
	var difficulty = 0

	difficulty += int(remap(time, 300.0, 180.0, 0, 30))
	difficulty += int(remap(float(reputation), float(maxReputation), float(minReputation), 0, 30))
	difficulty += int(pirateChance * 0.3)
	difficulty += int(spaceDust * 0.1)
	difficulty += int(distanceFactor * 20)

	return clamp(difficulty, 0, 100)
