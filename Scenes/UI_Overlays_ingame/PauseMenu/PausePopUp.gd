extends Panel

func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(SceneManger.MenuSceneKey)

func _on_exit_button_pressed():
	Log.info("Exit Button pressed")
	get_tree().quit()

func _on_unpause_pressed():
	$"../../UIManager".togglePause()
