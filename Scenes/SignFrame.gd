extends ColorRect
var data = {} # { 0: Vector2(500, 500), 1: Vector2(600,600), 5: Vector2(700,700), 9: Vector2(800,800) }
var inv = {} # id: type

const lineWidth = 5

func drawStars():
	queue_redraw()
	
func _draw(): # frameSize = (574, 422)
	if not data:
		return
	var starData = data["stars"]
	var connectionsData = data["connections"]
	
	for star in starData:
		if star not in inv.keys():
			print("[Error] Star not in Inventory!: id: ", star)
			continue
		var isStarBig = inv[star] == 1
		var isStarActive = inv[star] < 0
		
		var color = Color.YELLOW if isStarActive else Color.BLACK
		if abs(inv[star]) == 1: # big
			_create_big_star(_translateCoordinates(starData[star]), color)
		elif abs(inv[star]) == 2: # special
			_create_small_star(_translateCoordinates(starData[star]), color)
		else: # normal
			_create_small_star(_translateCoordinates(starData[star]), color)
		
	for con in connectionsData:
		var isActive = inv[con] >= 0 and inv[connectionsData[con]] >= 0
		draw_connection(starData[con], starData[connectionsData[con]], isActive)
		
func _translateCoordinates(coordinates: Vector2):
	return Vector2((coordinates.x * 100)/size.x, (coordinates.y*100)/size.y)

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
	var color = Color.YELLOW if isActive else Color.BLACK
	draw_line(_translateCoordinates(star1), _translateCoordinates(star2), color, lineWidth)
