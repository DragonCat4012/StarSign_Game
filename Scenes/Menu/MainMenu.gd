extends Node2D

@onready var PlayButton := $VBoxContainer/PlayButton
@onready var OptionsButton := $VBoxContainer/OptionsButton
@onready var ExitButton := $VBoxContainer/ExitButton
@onready var KeybindingsButton := $VBoxContainer/KeybindingsButton
@onready var verison_label = $VerisonLabel
@onready var animation_player_2 = $"../../Porcelain/AnimationPlayer2"
@onready var camera_3d = $"../../Camera3D"
var rotationCamera = -0.0005#0.01
@onready var color_rect = $ColorRect


# Selection
@onready var animation_player = $AnimationPlayer
@onready var op_1 := $Op1
@onready var op_2 := $Op2
@onready var op_3 := $Op3
@onready var op_4 := $Op4
@onready var allopt = [op_1, op_2, op_3, op_4]
var currentOpt = 0

var buttonLabels = ["Play", "Tutorial", "Options", "Keybindings"]
@onready var button_label = $ButtonLabelContainer/ButtonLabel
@onready var button_label_container = $ButtonLabelContainer
var button_labelPositionsY = []
@onready var animation_player_label = $ButtonLabelContainer/AnimationPlayer


func _ready():
	for e in allopt:
		e.modulate = Color("2f2f2f")
		button_labelPositionsY.append(e.position.y)
	allopt[0].modulate = Color("4c00a4")
	animation_player.animation_finished.connect(_on_animation_player_finished)
	button_label.text = buttonLabels[0]
	
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
	
func _process(delta):
	if camera_3d.rotation_degrees.y >= -40 or camera_3d.rotation_degrees.y <= -80:
		rotationCamera = -rotationCamera
	camera_3d.rotate_y(rotationCamera)
		
func _play_button_pressed():
	get_tree().change_scene_to_file(SceneManger.gameScene)
	
func _options_button_pressed():
	print("TODO: Button Options pressed")
	
func _keybindings_button_pressed():
	get_tree().change_scene_to_file(SceneManger.KeybindingsScene)
	
func _exit_button_pressed():
	get_tree().quit()

func _on_tutorial_button_pressed():
	color_rect.visible = true # TODO: is necesary?
	var scene = load(SceneManger.tutorialScene)
	get_tree().change_scene_to_packed(scene)

var lastAniamtionWasLine1 = false
func move_option_lines():
	button_label_container.visible = false
	if currentOpt == 0:
		return
		
	if animation_player.get_queue().size() < 1:
		if currentOpt%2 == 0:
			if not lastAniamtionWasLine1:
				animation_player.queue("line1")
				lastAniamtionWasLine1 = true
		else: 
			if lastAniamtionWasLine1:
				animation_player.queue("line2")
				lastAniamtionWasLine1 = false
	# Highlight selected
	for e in allopt:
		e.modulate = Color("2f2f2f")
	allopt[currentOpt-1].modulate = Color("4c00a4")
		

func _on_animation_player_finished(name):
	animation_player_label.play("fade-in")
	button_label_container.position.y = button_labelPositionsY[currentOpt-1]
	button_label.text = buttonLabels[currentOpt-1]
	button_label_container.visible = true

func _on_c_2_mouse_entered():
	currentOpt = 2
	move_option_lines()

func _on_c_1_mouse_entered():
	currentOpt = 1
	move_option_lines()

func _on_c_3_mouse_entered():
	currentOpt = 3
	move_option_lines()

func _on_c_4_mouse_entered():
	currentOpt = 4
	move_option_lines()
