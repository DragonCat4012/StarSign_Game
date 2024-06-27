extends Panel
@onready var b1 := $ColorRect/VBoxContainer/Button
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

@onready var pageNameLabel := $PageName
@onready var signRessource = preload("res://Ressources/Inventory/starSignMapping.tres")
@onready var starSignStarCountLabel := $StarCountForSign
@onready var backgroundTexture := $SignFrame

var star_dict = {}
var selectedSign = 0

func _ready():
	_on_button_pressed(0)
	for i in range(buttons.size()):
		buttons[i].pressed.connect(self._on_button_pressed.bind(i))

func _on_button_pressed(num):
	selectedSign = num
	pageNameLabel.text = str(num)
	starSignStarCountLabel.text = "0 / " + str(signRessource.get_stars(num).size())
	queue_redraw()

func _draw():
	backgroundTexture.data = signRessource.get_drawing_data(selectedSign)
	backgroundTexture.inv = signRessource.get_star_types_in_inventory()
	backgroundTexture.queue_redraw()
