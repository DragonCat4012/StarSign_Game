extends Node3D

@onready var compass = $UIOverlay/Compass
@onready var needle = $UIOverlay/Clock/Needle
var hasMoved = false

func _ready():
	EventSystem.MovementEnterd.connect(_on_movement_collison_entered)

func _process(delta: float):
	if Input.is_action_just_pressed("drawWeapon"):
		GameManager._toggle_weapon()
		
	compass._updateTexture($Player.compassDirection)

func _on_movement_collison_entered():
	hasMoved = true
