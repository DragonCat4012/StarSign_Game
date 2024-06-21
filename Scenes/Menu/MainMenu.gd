extends Node2D

@onready var PlayButton := $VBoxContainer/PlayButton
@onready var OptionsButton := $VBoxContainer/OptionsButton
@onready var ExitButton := $VBoxContainer/ExitButton

func _ready():
	PlayButton.pressed.connect(self._play_button_pressed.bind())
	OptionsButton.pressed.connect(self._options_button_pressed.bind())
	ExitButton.pressed.connect(self._exit_button_pressed.bind())
		
func _play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameScene.tscn")
	
func _options_button_pressed():
	print("TODO: Button Options pressed")
	
func _exit_button_pressed():
	get_tree().quit()
