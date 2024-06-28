extends ColorRect

var inv = {} # id: type
var starSign: StarSignModel

@onready var descritionLabel := $"../DescriptionFrame/DescriptionLabel"
@onready var descritionFrame := $"../DescriptionFrame"

const lineWidth = 2
const ACTIVE_STAR_COLOR := Color.WHITE
const INACTIVE_STAR_COLOR = Color.BLACK

func drawStars():
	queue_redraw()
	
func _draw(): # frameSize = (574, 422)
	_reset_drawn_stars()
	if not starSign:
		descritionLabel.text = ""
		descritionFrame.visible = false
		return
	
	descritionFrame.visible = true
	var starData = starSign.starMapping["stars"]
	var connectionsData = starSign.starMapping["connections"]
	
	for con in connectionsData:
		if not inv[connectionsData[con]] or not inv[con]:
			print("[Error] Star not laoded in Inventory Data!: ids: ", inv[connectionsData[con]], inv[con])
			continue 
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
	
	descritionLabel.text = starSign.starSignDescription
			
func _translateCoordinates(coordinates: Vector2):
	var new_x = coordinates.x if coordinates.x < size.x else (coordinates.x * 100)/size.x
	var new_y = coordinates.y if coordinates.y < size.y else (coordinates.y * 100)/size.y
	return Vector2(new_x, new_y)

func _create_small_star(base: Vector2, color: Color):
	#_draw_polygon_star(base, color, 10, 3)
	_draw_nodes(base, color==Color.WHITE, 1)
		
func _create_big_star(base: Vector2, color: Color):
	_draw_nodes(base, color==Color.WHITE, 2)
	#_draw_polygon_star(base, color, 20, 4)
	
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
	
func _reset_drawn_stars():
	for n in get_children():
		if n is Label:
			continue
		remove_child(n)	
		
func _draw_nodes(positionVec: Vector2, isActice: bool, type: int):
	var node = TextureRect.new()
	node.texture = load(_textureMapping[type][isActice])
	node.scale = Vector2(0.1, 0.1)
	node.position = positionVec - Vector2(25, 25)
	node.tooltip_text = "EEE"
	add_child(node)

var _textureMapping= {
	1: { true: "res://Ressources/Stars/invStar_1_on.svg", false: "res://Ressources/Stars/invStar_1_off.svg"},
	2: {true: "res://Ressources/Stars/invStar_2_on.svg", false: "res://Ressources/Stars/invStar_2_off.svg"}
}
