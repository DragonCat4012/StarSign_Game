extends Label

#signal unpauseGame
#signal pauseGame

@onready var exitButton := $"../../PausePopUp/ExitButton"

var stars := 0

# Inventory
var isInvShown = false
var pauseMenuShown = false

func _ready():
	exitButton.pressed.connect(self._button_pressed.bind())
	updateLabel()

func _on_star_star_collected():
	stars += 1
	updateLabel()

func updateLabel():
	text = "Stars: " + str(stars)
	
func _input(event):
	if event.is_action_pressed("UI_Pause") and not isInvShown:
		togglePause()
		
	if event.is_action_pressed("UI_Inv") and not pauseMenuShown:
		toggleInventory()
		
func _on_unpause_button_pressed():
	print("Toggle Pause")
	togglePause()

func togglePause():
	get_tree().paused = not get_tree().paused
		
	if get_tree().paused:
		pauseMenuShown = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$"../../PausePopUp".show()
		#emit_signal("pauseGame")
	else:
		pauseMenuShown = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$"../../PausePopUp".hide()
		#emit_signal("unpauseGame")
		
func toggleInventory():
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		isInvShown = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$"../../InventoryPanel".show()
		#emit_signal("pauseGame")
	else:
		isInvShown = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$"../../InventoryPanel".hide()
		#emit_signal("unpauseGame")	
		
func _button_pressed():
	print("Button Exit pressed")
	get_tree().quit()

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")

