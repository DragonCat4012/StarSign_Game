extends Node3D

signal activateSword
signal hideWeapon
var weaponactive = false

func _physics_process(delta):
	if $Player.position.y < -75:
		print("Playerr died due to height :c")
		get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
	
func _process(delta: float):
	if Input.is_action_just_pressed("drawWeapon"):
		if weaponactive:
			weaponactive = false
			emit_signal("hideWeapon")
		else:
			weaponactive = true
			emit_signal("activateSword")
