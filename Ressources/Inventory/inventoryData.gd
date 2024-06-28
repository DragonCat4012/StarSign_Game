extends Resource
class_name InventoryData

var allStars: Array[Star] = [
	load("res://Ressources/Stars/star0.tres"),
	load("res://Ressources/Stars/star1.tres"),
	load("res://Ressources/Stars/star2.tres"),
	load("res://Ressources/Stars/star5.tres"),
	load("res://Ressources/Stars/star9.tres")
]
	
func get_inventory() -> Array[Star]: # TODO not used currently
	return allStars.filter(func(element): return element.collected)

func get_star_types_in_inventory(): # id: type
	# Maps ids to types for drawing them, negtaive numbers if not collected
	var dict = {}
	for star in allStars:
		dict[star.starId] = star.starType if star.collected else (-1)*star.starType
	return dict
