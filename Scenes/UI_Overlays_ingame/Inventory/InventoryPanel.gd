extends Panel
@onready var b1 := $ColorRect/VBoxContainer/Button1
@onready var b2 := $ColorRect/VBoxContainer/Button2
@onready var b3 := $ColorRect/VBoxContainer/Button3
@onready var b4 := $ColorRect/VBoxContainer/Button4
@onready var b5 := $ColorRect/VBoxContainer/Button5
@onready var b6 := $ColorRect/VBoxContainer/Button6
@onready var b7 := $ColorRect/VBoxContainer/Button7
@onready var b8 := $ColorRect/VBoxContainer/Button8
@onready var b9 := $ColorRect/VBoxContainer/Button9
@onready var b10 := $ColorRect/VBoxContainer/Button10
@onready var b11 := $ColorRect/VBoxContainer/Button11
@onready var b12 := $ColorRect/VBoxContainer/Button12
@onready var buttons = [b1, b2, b3, b4, b5, b6, b7, b8, b9 ,b10, b11, b12]

@onready var activateWeaponButton := $ActivateButton
@onready var weaponNameLabel := $WeaponNameLabel

@onready var pageNameLabel := $PageName
@onready var signRessource = preload("res://Ressources/Inventory/starSignMapping.tres")
@onready var starSignStarCountLabel := $StarCountForSign
@onready var backgroundTexture := $SignFrame

@onready var weapon_preview = $SubViewportContainer/SubViewport/WeaponPreview

var star_dict = {}
var selectedSign = 0
var selectedWeaponId = 0
var possibleNextWeapon: WeaponModel
var collectedStarsInInventory = []

func _ready():
	activateWeaponButton.pressed.connect(self._on_activate_weapon_pressed)
	
	_on_button_pressed(0)
	for i in range(buttons.size()):
		buttons[i].pressed.connect(self._on_button_pressed.bind(i))

func _on_button_pressed(num):
	selectedSign = num
	queue_redraw()
	
func _on_activate_weapon_pressed():
	$"../../UIManager".toggleInventory()
	GameManager.currentWeapon = possibleNextWeapon
	GameManager.activate_weapon_from_inventory(selectedWeaponId)

func _draw():
	selectedWeaponId = 0
	
	var data: StarSignModel = load("res://Ressources/Stars/StarSigns/" + str(selectedSign) + ".tres")
	backgroundTexture.starSign = data
	
	if not data:
		pageNameLabel.text = "???"
		starSignStarCountLabel.text = "??? / ???"
		backgroundTexture.queue_redraw()
		weapon_preview.stop()
		return
		
	pageNameLabel.text = data.starSignName
	
	activateWeaponButton.visible = false
	weaponNameLabel.text = "???"
	var starSignCountData = signRessource.get_needed_starts_for_sign(data)
	
	if starSignCountData.x == starSignCountData.y: # All needed stars collected
		activateWeaponButton.visible = true
		var weapon = data.weaponRessource
		weaponNameLabel.text = weapon.weaponName
		selectedWeaponId = weapon.weaponID
		weapon_preview.start(weapon.weaponName)
		possibleNextWeapon = weapon
	else:
		weapon_preview.stop()
	starSignStarCountLabel.text = str(starSignCountData.x) + " / " + str(starSignCountData.y)
		
	backgroundTexture.inv = signRessource.get_star_types_in_inventory()
	backgroundTexture.queue_redraw()


func _set_button_visibility():
	for but in buttons:
		var neededStars = but.starSign.get_stars()
		if not _arrays_have_overlapping_content(neededStars, collectedStarsInInventory):
			# Player has one star of the sign so he should be able to view it
			but.disabled  = true
			but.focus_mode = FOCUS_NONE
		else: # Player doesnt have any stars of the sign, should be hidden
			but.focus_mode = FOCUS_ALL
			but.disabled  = false

func _arrays_have_overlapping_content(array1, array2) -> bool:
	# Checks if two arrays have one overlapping element
	for item in array1:
		if array2.has(item): return true
	for item in array2:
		if array1.has(item): return true
	return false

func _on_star_counter_inventory_will_be_shown():
	if GameManager.isDebug:
		return
	# prepares button visbillity
	collectedStarsInInventory = signRessource.get_all_collected_stars()
	_set_button_visibility()
