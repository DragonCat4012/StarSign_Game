extends Control
# Manage UI
var isInvShown = false
var pauseMenuShown = false

@onready var pause_pop_up = $"../UIOverlay/PausePopUp"
@onready var inventory_panel = $"../UIOverlay/InventoryPanel"
@onready var star_progress_scene = $"../UIOverlay/StarProgressScene"
@onready var player = $".."

# Orientation
@onready var compass = $"../UIOverlay/Compass"
@onready var needle = $"../UIOverlay/Clock/Needle"
@onready var clock = $"../UIOverlay/Clock"

# Quests
@onready var quest_rect = $"../UIOverlay/QuestRect"
@onready var quest_label = $"../UIOverlay/MapPopups/QuestTitle"
@onready var quest_title_animation_player = $"../UIOverlay/MapPopups/AnimationPlayer"
@onready var quest_title = $"../UIOverlay/MapPopups/QuestTitle"
@onready var quest_subtitle = $"../UIOverlay/MapPopups/Subtitle"
@onready var map_popups = $"../UIOverlay/MapPopups"

func _ready():
	inventory_panel.visible = false
	pause_pop_up.visible = false
	compass.visible = false
	clock.visible = false
	quest_rect.visible = false
	map_popups.visible = false
	
func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta: float):
	if Input.is_action_just_pressed("drawWeapon"):
		GameManager._toggle_weapon()
		
	compass._updateTexture(player.compassDirection)
	needle.rotation_degrees += 2*GameManager.TIME_PER_DAY # 12 hour format
	
func _input(event):
	if event.is_action_pressed("UI_Pause") and not isInvShown:
		togglePause()
	elif event.is_action_pressed("UI_Pause"): # hide inventory
		toggleInventory()
		
	if event.is_action_pressed("UI_Inv") and not pauseMenuShown:
		toggleInventory()
	
	if not pauseMenuShown:
		if event.is_action_pressed("UI_Detail") or event.is_action_released("UI_Detail"):
			toggleDetails()	
		
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
		star_progress_scene.visible = false
		compass.visible = false
		#emit_signal("pauseGame")
	else:
		isInvShown = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		inventory_panel.hide()
		star_progress_scene.visible = true
		compass.visible = true
		#emit_signal("unpauseGame")	

func toggleDetails():
	compass.visible = !compass.visible
	clock.visible = !clock.visible
	quest_rect.visible = !quest_rect.visible
	
# Quest Board
func _update_quest_board():
	var quest_box = $"../UIOverlay/QuestRect/QuestBox"
	var quest_container = $"../UIOverlay/QuestRect/QuestBox/QuestContainer"
	
	for child in quest_box.get_children():
		quest_container.remove_child(child)
		child.queue_free()
	
	for quest in QuestManager.get_quest_array():	
		var newOne = quest_container.duplicate()
		newOne.visible = true
	
		for child in newOne.get_children():
			if child.name == "DefaultQuestLabel":
				child.text = quest
	
		quest_box.add_child(newOne)

func addQuest(title: String, subtitle: String):
	print("Show questboard")
	_showQuestTitle("New Quest", subtitle)
	QuestManager.add_quest(Quest.new(title, subtitle, ""))
	_update_quest_board()

func removeQuest(title: String):
	var quest_containerAll = $"../UIOverlay/QuestRect/QuestBox"
	
	for questContainer in quest_containerAll.get_children(): # every quest
		for child in questContainer.get_children(): #  every node in quest
			if child.name == "DefaultQuestLabel":
				if child.text == title:
					quest_containerAll.remove_child(questContainer)
					QuestManager.remove_quest_from_title(title)

# Quest Titles
func _showQuestTitle(title: String, subtitle: String):
	quest_title.text = title
	quest_subtitle.text = subtitle
	map_popups.visible = true
	quest_title_animation_player.play("fade_in")
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 2.2
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(_hideQuestTitle)
	
func _hideQuestTitle():
	quest_title_animation_player.play("fade_out")
