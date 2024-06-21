extends Label

#signal unpauseGame
#signal pauseGame

@onready var exitButton := $"../../PausePopUp/ExitButton"

var stars := 0

# Inventory
var isInvShown = false

func _ready():
	exitButton.pressed.connect(self._button_pressed.bind())
	updateLabel()

func _on_star_star_collected():
	stars += 1
	updateLabel()

func updateLabel():
	text = "Stars: " + str(stars)
	
func _input(event):
	if event.is_action_pressed("UI_Pause"):
		togglePause()
		
	if event.is_action_pressed("UI_Inv"):
		toggleInventory()
		
func _on_unpause_button_pressed():
	print("Toggle Pause")
	togglePause()

func togglePause():
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$"../../PausePopUp".show()
		#emit_signal("pauseGame")
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$"../../PausePopUp".hide()
		#emit_signal("unpauseGame")
		
func toggleInventory():
	get_tree().paused = not get_tree().paused
	isInvShown = !get_tree().paused
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$"../../InventoryPanel".show()
		#emit_signal("pauseGame")
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$"../../InventoryPanel".hide()
		#emit_signal("unpauseGame")	
		
func _button_pressed():
	print("Button Exit pressed")
	get_tree().quit()
