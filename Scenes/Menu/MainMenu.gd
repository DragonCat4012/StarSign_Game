extends Node2D

@onready var PlayButton := $VBoxContainer/PlayButton
@onready var OptionsButton := $VBoxContainer/OptionsButton
@onready var ExitButton := $VBoxContainer/ExitButton
@onready var KeybindingsButton := $VBoxContainer/KeybindingsButton
@onready var verison_label = $VBoxContainer/VerisonLabel
@onready var animation_player_2 = $"../../Porcelain/AnimationPlayer2"
@onready var camera_3d = $"../../Camera3D"
var rotationCamera = 0.01

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
	animation_player_2.speed_scale = 0.7
	animation_player_2.play("idle")
	
func _process(delta):
	camera_3d.rotate_y(deg_to_rad(rotationCamera))
	if camera_3d.rotation_degrees.y >= -10 or camera_3d.rotation_degrees.y <= -95:
		rotationCamera = rotationCamera*(-1)
		
func _play_button_pressed():
	get_tree().change_scene_to_file(SceneManger.gameScene)
	
func _options_button_pressed():
	print("TODO: Button Options pressed")
	
func _keybindings_button_pressed():
	get_tree().change_scene_to_file(SceneManger.KeybindingsScene)
	
func _exit_button_pressed():
	get_tree().quit()

func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file(SceneManger.tutorialScene)
