extends Node3D

var hasMoved = false
@onready var ui_manager = $Player/%UIManager

func _ready():
	EventSystem.MovementEnterd.connect(_on_movement_collison_entered)
	ui_manager.addQuest("New Grounds", "Walk through the pillars. Use WASD to move")

func _on_movement_collison_entered():
	hasMoved = true
	ui_manager.removeQuest("New Grounds")
