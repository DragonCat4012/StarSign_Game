extends Node3D

@onready var quest_rect = $Control/QuestRect
@onready var quest_label = $Control/QuestRect/Label

var hasMoved = false

func _ready():
	EventSystem.MovementEnterd.connect(_on_movement_collison_entered)
	quest_rect.visible = true
	quest_label.text = "Walk through the pillars?"

func _on_movement_collison_entered():
	hasMoved = true
	quest_rect.visible = false
