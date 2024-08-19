extends HBoxContainer
signal EditPressed(title, currentBinding)

@export var inputMapName := "Move_Jump"
@export var titleValue := "Title"

@onready var title := $Title
@onready var key := $Key
@onready var edit := $Edit

var activeColor = Color("b6a0f8")

func _ready():
	title.text = titleValue
	key.text = "-"
	_normalize()

func _on_edit_pressed():
	EditPressed.emit(inputMapName, key.text)
	_highlight()

func deactivate():
	edit.disabled = true
	
func activate():
	edit.disabled = false

func update_key(keyVal):
	key.text = keyVal
	edit.focus_mode = FOCUS_NONE
	_normalize()
	
func _highlight():
	title.set("theme_override_colors/font_color", activeColor)
	key.set("theme_override_colors/font_color", activeColor)

func _normalize():
	title.set("theme_override_colors/font_color", Color.WHITE)
	key.set("theme_override_colors/font_color", Color.GRAY)
