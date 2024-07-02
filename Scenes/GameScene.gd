extends Node3D
@onready var compass = $UIOverlay/Compass
@onready var needle = $UIOverlay/Clock/Needle

func _physics_process(delta):
	if $Player.position.y < -75:
		Log.info("Player died due to height :c")
		get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")

func _process(delta: float):
	if Input.is_action_just_pressed("drawWeapon"):
		GameManager._toggle_weapon()
		
	compass._updateTexture($Player.compassDirection)
	$DirectionalLight3D.rotate_x(deg_to_rad(0.1))
	needle.rotation_degrees += 0.1
