extends HBoxContainer
signal EditPressed(title)

@export var inputMapName := "Move_Jump"
@export var titleValue := "Title"
@export var keyValue := "Key"

@onready var title := $Title
@onready var key := $Key
@onready var edit := $Edit

func _ready():
	title.text = titleValue
	key.text = keyValue

func _on_edit_pressed():
	EditPressed.emit(inputMapName)

func deactivate():
	edit.disabled = true
	
func activate():
	edit.disabled = false

func update_key(keyVal):
	key.text = keyVal
