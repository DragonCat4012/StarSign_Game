extends Resource
class_name InventoryData

var allStars: Array[Star] = [
	load("res://Ressources/Stars/star0.tres"),
	load("res://Ressources/Stars/star1.tres"),
	load("res://Ressources/Stars/star5.tres"),
	load("res://Ressources/Stars/star9.tres")
]
var starSignnameMapping = {
	0: "Starsign nameless",
	1: "Aloha Starsign"
}

var starPositions = {
	0: { "stars": { 0: Vector2(500, 500), 1: Vector2(600,600), 5: Vector2(700,700), 9: Vector2(800,800) },
	"connections": {0:5} },
	1: { "stars": { 0: Vector2(0, 100), 5: Vector2(300,100), 9: Vector2(200,200), 1: Vector2(574, 422) },
	"connections": {0:5, 9:0} },
}

# Getting Stats
func get_stars(num: int) -> Array[int]:
	var arr: Array[int] = []
	if num in starPositions.keys():
		arr.assign(starPositions[num]["stars"].keys())
	return arr

func get_starsign_name(num: int) -> String:
	return starSignnameMapping[num] if num in starSignnameMapping.keys() else "???"
	
# Drawing Starsigns
func get_drawing_data(num: int):
	if num not in starPositions.keys():
		print("[Error] Starsign not found: ", num)
		return {}
	return starPositions[num]
	
func get_inventory() -> Array[Star]: # TODO not used currently
	return allStars.filter(func(element): return element.collected)

func get_star_types_in_inventory(): # id: type
	# Maps ids to types for drawing them, negtaive numbers if not collected
	var dict = {}
	for star in allStars:
		dict[star.starId] = star.starType
		if not star.collected:
			dict[star.starId] = -star.starType
	return dict
