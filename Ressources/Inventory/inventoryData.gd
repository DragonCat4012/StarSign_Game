extends Resource
class_name InventoryData

@export var mapping = {
	0: [0,1,5,9]
}

var starPositions = {
	0: { "stars": { 0: Vector2(500, 500), 1: Vector2(600,600), 5: Vector2(700,700), 9: Vector2(800,800) },
	"connections": {} }
}

# starsign: [ star:position ]

func getStars(num: int) -> Array[int]:
	var arr: Array[int] = []
	if num in mapping.keys():
		arr.assign(mapping[num])
	return arr
