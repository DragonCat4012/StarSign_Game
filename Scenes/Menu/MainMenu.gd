extends Node2D

@onready var PlayButton := $VBoxContainer/PlayButton
@onready var OptionsButton := $VBoxContainer/OptionsButton
@onready var ExitButton := $VBoxContainer/ExitButton
@onready var KeybindingsButton := $VBoxContainer/KeybindingsButton
@onready var verison_label = $VBoxContainer/VerisonLabel

func _ready():
	PlayButton.pressed.connect(self._play_button_pressed.bind())
	OptionsButton.pressed.connect(self._options_button_pressed.bind())
	KeybindingsButton.pressed.connect(self._keybindings_button_pressed.bind())
	ExitButton.pressed.connect(self._exit_button_pressed.bind())
	
	var preset = ConfigFile.new()
	preset.load("res://export_presets.cfg")
	var version = preset.get_value("preset.0.options", "application/file_version")
	var build =  preset.get_value("preset.0.options", "application/product_version")
	verison_label.text = version + " (" + build + ")"
		
func _play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameScene.tscn")
	
func _options_button_pressed():
	print("TODO: Button Options pressed")
	
func _keybindings_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/Keybindings.tscn")
	
func _exit_button_pressed():
	get_tree().quit()
