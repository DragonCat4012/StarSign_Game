extends Node2D

@onready var compassNode := $CenterContainer/CompassBar

func _ready():
	compassNode.set_stretch_mode(TextureRect.STRETCH_KEEP_CENTERED)
	compassNode.set_texture_repeat(CanvasItem.TEXTURE_REPEAT_ENABLED)
	
func _updateTexture(degree):
	"""if degree > 90:
		print("South")
	elif degree > 0:
		print("West")
	elif degree > -90:
		print("North")
	elif degree > -180:
		print("East")"""

	var currentDirection = compassNode.material.get_shader_parameter("dir")
	compassNode.material.set_shader_parameter("dir", deg_to_rad(degree))
	#material.set_shader_parameter("dir", lerp_angle(currentDirection, degree, 0.1))
