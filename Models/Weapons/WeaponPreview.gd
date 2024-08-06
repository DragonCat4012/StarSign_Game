extends Node3D
@onready var weapons = $Weapons
var currentChild: Node3D = null

func _ready():
	for ch in weapons.get_children():
		ch.visible = false
		
func _process(_delta):
	if not currentChild:
		return
	currentChild.rotation = currentChild.rotation + Vector3(0, 0.01, 0)
	
func start(childname):
	for ch in weapons.get_children():
		if ch.name == childname.to_lower():
			print("e")
			ch.visible = true
			currentChild = ch
			currentChild.rotation = Vector3(0, 0, 0)
		else:
			ch.visible = false

func stop():
	if currentChild:
		currentChild.visible = false 
		currentChild = null
