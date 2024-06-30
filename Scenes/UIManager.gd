extends Control
# Manage UI
var isInvShown = false
var pauseMenuShown = false

@onready var pause_pop_up = $UIManager/PausePopUp
@onready var compass = $UIManager/Compass
@onready var inventory_panel = $UIManager/InventoryPanel
@onready var star_progress_scene = $UIManager/StarProgressScene
	
func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event.is_action_pressed("UI_Pause") and not isInvShown:
		togglePause()
		
	if event.is_action_pressed("UI_Inv") and not pauseMenuShown:
		toggleInventory()
		
func togglePause():
	get_tree().paused = not get_tree().paused
		
	if get_tree().paused:
		pauseMenuShown = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_pop_up.show()
	else:
		pauseMenuShown = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		pause_pop_up.hide()
		#emit_signal("unpauseGame")
		
func toggleInventory():
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		isInvShown = true
		EventSystem.InventoryWillBeShown.emit()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		inventory_panel.show()
		$StarProgressScene.visible = false
		compass.visible = false
		#emit_signal("pauseGame")
	else:
		isInvShown = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		inventory_panel.hide()
		$StarProgressScene.visible = true
		compass.visible = true
		#emit_signal("unpauseGame")	
