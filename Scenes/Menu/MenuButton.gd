extends Control
@onready var animation_player = $Option/AnimationPlayer
@onready var texture_rect := $Option/TextureRect
@onready var color_rect := $Option/ColorRect
@onready var option = $Option

@export var optionNum: int = 1
@export var icon: Texture

@export var inactiveColor: Color = Color("2f2f2f")
@export var activeColor: Color = Color("956dff")

var clicked = false

func _ready():
	clicked = false
	option.color = inactiveColor
	color_rect.color = inactiveColor
	texture_rect.texture = icon
	
func _on_c_1_mouse_entered():
	EventSystem.EnteredOption.emit(optionNum)
	texture_rect.modulate = activeColor
	animation_player.play("scale_up")
	animation_player.play("pulse")

func _on_c_1_mouse_exited():
	EventSystem.ExitedOption.emit(optionNum)
	texture_rect.modulate = Color.WHITE
	animation_player.play("scale_down")

func _on_c_1_gui_input(event):
	if event is InputEventMouseButton and not clicked:
		clicked = true
		print("ay")
		EventSystem.ClickedOption.emit(optionNum)
