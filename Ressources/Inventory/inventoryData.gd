extends Resource
class_name InventoryData

const File_name = "user://saves.json"
var SaveFileJSON = {
	"collectedStarIds": [0],
	"position": [0,0],
	"health": 100,
	"weaponID": 0
}

var allStars: Array[Star] = [
	load("res://Ressources/Stars/Stars/star0.tres"),
	load("res://Ressources/Stars/Stars/star1.tres"),
	load("res://Ressources/Stars/Stars/star2.tres"),
	load("res://Ressources/Stars/Stars/star3.tres"),
	load("res://Ressources/Stars/Stars/star4.tres"),
	load("res://Ressources/Stars/Stars/star5.tres"),
	load("res://Ressources/Stars/Stars/star9.tres")
]

func _init():
	_load_data() # updates saveedData
	_debug_stars()
	_update_collected_stars()
	
func get_all_collected_stars() -> Array[int]:
	var arr: Array[int] = []
	arr.assign(SaveFileJSON["collectedStarIds"])
	return arr

func get_star_count() -> int:
	return SaveFileJSON["collectedStarIds"].size()
	
func get_star_types_in_inventory(): # id: type
	# Maps ids to types for drawing them, negtaive numbers if not collected
	var dict = {}
	for star in allStars:
		dict[star.starId] = star.starType if star.collected else (-1)*star.starType
	return dict

func get_needed_starts_for_sign(sign: StarSignModel) -> Vector2:
	# Returns (collectedStars, neddedStars)
	var vec = Vector2(0, sign.get_star_count())
	for starID in sign.get_stars():
		if starID in SaveFileJSON["collectedStarIds"]:
			vec.x += 1
	return vec
	
func _update_collected_stars():
	var starIDS: Array[int] = []
	starIDS.assign(SaveFileJSON["collectedStarIds"])
	
	for star in allStars:
		if star.starId not in starIDS:
			star.collected = false
		else:
			star.collected = true

func add_collected_star(id: int):
	var arr: Array[int] = []
	arr.assign(SaveFileJSON["collectedStarIds"])
	
	if not id in arr:
		arr.append(id)
		
	SaveFileJSON["collectedStarIds"] = arr
	_save_data()
	
	# Update collected Stars
	for star in allStars:
		if star.starId == id:
			star.collected = true
	
# Load and Store Data
func _load_data():
	if FileAccess.file_exists((File_name)):
		var file = FileAccess.open(File_name, FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		
		if not dict:
			return
		
		print("Load File Save: ", dict)
		
		for key in SaveFileJSON.keys():
			if key in dict.keys():
				SaveFileJSON[key] = dict[key]
			else:
				print("Missing key: ", key)
		remove_duplicate_star_ids()
	else:
		print("Save File doesnt exist")
		
func _save_data():
		var saveDict = {}
		var file = FileAccess.open(File_name, FileAccess.WRITE)
		remove_duplicate_star_ids()
		
		for key in SaveFileJSON.keys():
			saveDict[key] = SaveFileJSON[key]

		print("Saving: ", saveDict)
		
		file.store_string(JSON.stringify(saveDict))
		file.close()

func remove_duplicate_star_ids():
	var arr = []
	var current = SaveFileJSON["collectedStarIds"]
	for x in current:
		if x not in arr:
			arr.append(x)
	SaveFileJSON["collectedStarIds"] = arr

func _debug_stars():
	SaveFileJSON["collectedStarIds"] = [0]
