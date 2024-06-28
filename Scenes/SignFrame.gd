extends ColorRect

var data = {} # { 0: Vector2(500, 500), 1: Vector2(600,600), 5: Vector2(700,700), 9: Vector2(800,800) }
var inv = {} # id: type
var descrition = ""

@onready var descritionLabel = $"../DescriptionFrame/DescriptionLabel"

const lineWidth = 2
const ACTIVE_STAR_COLOR := Color.WHITE
const INACTIVE_STAR_COLOR = Color.BLACK

func drawStars():
	queue_redraw()
	
func _draw(): # frameSize = (574, 422)
	if not data:
		return
	var starData = data["stars"]
	var connectionsData = data["connections"]
	
	for con in connectionsData:
		var isActive = inv[con] >= 0 and inv[connectionsData[con]] >= 0
		draw_connection(starData[con], starData[connectionsData[con]], isActive)
		
	for star in starData:
		if star not in inv.keys():
			print("[Error] Star not in Inventory!: id: ", star)
			continue
		var isStarBig = inv[star] == 1
		var isStarActive = inv[star] >= 0
		
		var color = ACTIVE_STAR_COLOR if isStarActive else INACTIVE_STAR_COLOR
		if abs(inv[star]) == 1: # big
			_create_big_star(_translateCoordinates(starData[star]), color)
		elif abs(inv[star]) == 2: # special
			_create_small_star(_translateCoordinates(starData[star]), color)
		else: # normal
			_create_small_star(_translateCoordinates(starData[star]), color)
	
	descritionLabel.text = descrition
			
func _translateCoordinates(coordinates: Vector2):
	var new_x = coordinates.x if coordinates.x < size.x else (coordinates.x * 100)/size.x
	var new_y = coordinates.y if coordinates.y < size.y else (coordinates.y * 100)/size.y
	return Vector2(new_x, new_y)

func _create_small_star(base: Vector2, color: Color):
	_draw_polygon_star(base, color, 10, 3)
	
func _create_big_star(base: Vector2, color: Color):
	_draw_polygon_star(base, color, 20, 4)
	
func _draw_polygon_star(base: Vector2, color: Color, val, foo):
	var star_coordinates: Array[Vector2]= [
	base+Vector2(0, val), 
	base+Vector2(val/foo, val/foo), 
	base+Vector2(val, 0), 
	base+Vector2(val/foo, -val/foo), 
	base+Vector2(0, -val) , 
	base+Vector2(-val/foo, -val/foo), 
	base+Vector2(-val, 0), 
	base+Vector2(-val/foo, val/foo),
	]
	draw_polygon(star_coordinates, [color])

func draw_connection(star1: Vector2, star2: Vector2, isActive: bool):
	var color = ACTIVE_STAR_COLOR if isActive else INACTIVE_STAR_COLOR
	draw_line(_translateCoordinates(star1), _translateCoordinates(star2), color, lineWidth)
