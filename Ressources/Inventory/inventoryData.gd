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
	load("res://Ressources/Stars/star0.tres"),
	load("res://Ressources/Stars/star1.tres"),
	load("res://Ressources/Stars/star2.tres"),
	load("res://Ressources/Stars/star5.tres"),
	load("res://Ressources/Stars/star9.tres")
]

func _init():
	_load_data() # updates saveedData
	_update_collected_stars()

func get_star_types_in_inventory(): # id: type
	# Maps ids to types for drawing them, negtaive numbers if not collected
	var dict = {}
	for star in allStars:
		dict[star.starId] = star.starType if star.collected else (-1)*star.starType
	return dict

func _update_collected_stars():
	for star in allStars:
		if star.starId not in SaveFileJSON["collectedStarIds"]:
			star.collected = false
		else:
			star.collected = true

func add_collected_star(id: int):
	var arr = SaveFileJSON["collectedStarIds"]
	if id not in arr:
		pass
	arr.append(id)
	SaveFileJSON["collectedStarIds"] = arr
	
# Load and Store Data
func _load_data():
	if FileAccess.file_exists((File_name)):
		var file = FileAccess.open(File_name, FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		print("Load File Save: ", dict)
		if not dict:
			return
		
		for key in SaveFileJSON.keys():
			if key in dict.keys():
				SaveFileJSON[key] = dict[key]
			else:
				print("Missing key: ", key)
	else:
		print("Save File doesnt exist")
		
func _save_data():
		var saveDict = {}
		var file = FileAccess.open(File_name, FileAccess.WRITE)
		
		for key in SaveFileJSON.keys():
			saveDict[key] = SaveFileJSON[key]

		print("Saving: ", saveDict)
		
		file.store_string(JSON.stringify(saveDict))
		file.close()
