class_name StarSignModel extends Resource

@export var starSignId = 0
@export var starSignName = "Default starsignname"
@export var starSignDescription = "Default Starsign Description"
@export var starMapping =  { "stars": { },	"connections": {} }
@export var weaponRessource: WeaponModel = null

func load_needed_star_ressources() -> Array[Star]:
	var arr = []
	for star in starMapping["stars"].keys():
		var str = "res://Ressources/Stars/star" + str(star) + ".tres"
		arr.append(load(str))
	return arr

func get_star_count() -> int:
	return starMapping["stars"].keys().size()

func get_stars() -> Array[int]:
	var arr: Array[int] = []
	arr.assign(starMapping["stars"].keys())
	return arr
