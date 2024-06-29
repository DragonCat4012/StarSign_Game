extends Node3D

func _physics_process(delta):
	if $Player.position.y < -75:
		Log.info("Player died due to height :c")
		get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
	
func _process(delta: float):
	if Input.is_action_just_pressed("drawWeapon"):
		GameManager._toggle_weapon()
		
	$Compass._updateTexture($Player.compassDirection)
