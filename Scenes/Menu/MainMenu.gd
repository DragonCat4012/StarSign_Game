extends Node2D

@onready var PlayButton := $VBoxContainer/PlayButton
@onready var OptionsButton := $VBoxContainer/OptionsButton
@onready var ExitButton := $VBoxContainer/ExitButton
@onready var KeybindingsButton := $VBoxContainer/KeybindingsButton
@onready var verison_label = $VerisonLabel
@onready var animation_player_2 = $"../../Porcelain/AnimationPlayer2"
@onready var camera_3d = $"../../Camera3D"
var rotationCamera = -0.0005#0.01


# Selection
@onready var animation_player = $AnimationPlayer
var currentOpt = 0

var buttonLabels = ["Play", "Options (WIP)", "Keybindings", "Tutorial"]
@onready var button_label = $ButtonLabelContainer/ButtonLabel
@onready var button_label_container = $ButtonLabelContainer
@onready var animation_player_label = $ButtonLabelContainer/AnimationPlayer

func _ready():
	button_label_container.visible = false
	button_label.text = buttonLabels[0]
	EventSystem.EnteredOption.connect(enteredOption)
	EventSystem.ExitedOption.connect(exitedOption)
	EventSystem.ClickedOption.connect(optionSelected)
	
	PlayButton.pressed.connect(self._play_button_pressed.bind())
	OptionsButton.pressed.connect(self._options_button_pressed.bind())
	KeybindingsButton.pressed.connect(self._keybindings_button_pressed.bind())
	ExitButton.pressed.connect(self._exit_button_pressed.bind())
	
	# Load version Info
	var file = FileAccess.open("res://version.txt", FileAccess.READ)
	var version = file.get_as_text()
	file.close()
	verison_label.text = version
	
	# Play Idle animation
	animation_player_2.speed_scale = 0.7
	animation_player_2.play("idle")
		
func _play_button_pressed():
	get_tree().change_scene_to_file(SceneManger.gameScene)
	
func _options_button_pressed():
	print("TODO: Button Options pressed")
	
func _keybindings_button_pressed():
	get_tree().change_scene_to_file(SceneManger.KeybindingsScene)
	
func _exit_button_pressed():
	get_tree().quit()

func _on_tutorial_button_pressed():
	var scene = load(SceneManger.tutorialScene)
	get_tree().change_scene_to_packed(scene)
	
# Button animations
var textContainerPositions = [655, 860, 1055, 1275]
var lastOption = 0
func move_option_lines():
	if currentOpt == 0:
		button_label_container.visible = false
		return
		
	button_label.text = buttonLabels[currentOpt-1]
	if not lastOption == currentOpt:
		button_label_container.position.y = textContainerPositions[currentOpt-1]
		button_label_container.visible = false
		animation_player_label.play("fade-in")
		button_label_container.visible = true	
		
func enteredOption(opt):
	lastOption = currentOpt
	currentOpt = opt
	move_option_lines()
	
func exitedOption(opt):
	currentOpt = 0
	move_option_lines()

func optionSelected(opt):
	match opt:
		1:
			_play_button_pressed()
		2: 
			_options_button_pressed()
		3:
			_keybindings_button_pressed()
		4:
			_on_tutorial_button_pressed()
