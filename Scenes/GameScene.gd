extends Node3D

func _physics_process(delta):
	if $Player.position.y < -75:
		print("Playerr died due to height :c")
		get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
