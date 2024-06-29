extends Label

#signal unpauseGame
#signal pauseGame
signal inventoryWillBeShown

@onready var exitButton := $"../../PausePopUp/ExitButton"
@onready var fpsLabel := $"../FPSLabel"
var stars := 0

# Inventory
var isInvShown = false
var pauseMenuShown = false

func _ready():
	exitButton.pressed.connect(self._button_pressed.bind())
	var signRessource := load("res://Ressources/Inventory/starSignMapping.tres")
	updateLabel(signRessource.get_star_count())
	
func _process(delta: float) -> void:
	fpsLabel.text = "FPS: %s" % [Engine.get_frames_per_second()]

func _input(event):
	if event.is_action_pressed("UI_Pause") and not isInvShown:
		togglePause()
		
	if event.is_action_pressed("UI_Inv") and not pauseMenuShown:
		toggleInventory()

# Handle collected Stars	
func _on_star_star_collected_2(id):
	print("Collect Star (in Counter) id: ", id)
	var signRessource := load("res://Ressources/Inventory/starSignMapping.tres")
	signRessource.add_collected_star(id)
	updateLabel(signRessource.get_star_count())
	
func updateLabel(count: int):
	text = "Stars: " + str(count)

# Handle Pause & Inventory Menu
func _on_unpause_button_pressed():
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
		inventoryWillBeShown.emit()
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
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
