extends Node3D
@onready var compass = $UIOverlay/Compass
@onready var needle = $UIOverlay/Clock/Needle
@onready var lightSource = $DirectionalLight3D
const TIME_PER_DAY = 0.05


func _physics_process(delta):
	if $Player.position.y < -75:
		Log.info("Player died due to height :c")
		get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")

func _process(delta: float):
	if Input.is_action_just_pressed("drawWeapon"):
		GameManager._toggle_weapon()
		
	compass._updateTexture($Player.compassDirection)
	lightSource.rotate_x(deg_to_rad(TIME_PER_DAY))

	if lightSource.rotation_degrees.x > 0: # Night
		lightSource.light_energy = 0.01
	else:
		lightSource.light_energy = 1.0 # Day
	needle.rotation_degrees += 2*TIME_PER_DAY
