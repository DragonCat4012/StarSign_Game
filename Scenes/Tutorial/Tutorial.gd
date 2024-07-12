extends Node3D

@onready var quest_rect = $UIOverlay/QuestRect
@onready var quest_label = $UIOverlay/QuestRect/Label

@onready var compass = $UIOverlay/Compass
var hasMoved = false

func _ready():
	EventSystem.MovementEnterd.connect(_on_movement_collison_entered)
	quest_rect.visible = true
	quest_label.text = "Walk through the pillars?"
	
func _process(delta: float):
	if Input.is_action_just_pressed("drawWeapon"):
		GameManager._toggle_weapon()
		
	compass._updateTexture($Player.compassDirection)

func _on_movement_collison_entered():
	hasMoved = true
	quest_rect.visible = false
