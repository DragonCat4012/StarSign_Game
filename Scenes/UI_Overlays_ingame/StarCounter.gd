extends Label

@onready var fpsLabel := $"../FPSLabel"
var stars := 0

func _ready():
	updateLabel(GameManager.INVENTORY.get_star_count())
	EventSystem.StarCollect.connect(_on_star_star_collected_2)
	_on_star_star_collected_2
	
func _process(delta: float) -> void:
	fpsLabel.text = "FPS: %s" % [Engine.get_frames_per_second()]

# Handle collected Stars	
func _on_star_star_collected_2(id):
	print("Collect Star (in Counter) id: ", id)
	var signRessource := load("res://Ressources/Inventory/starSignMapping.tres")
	signRessource.add_collected_star(id)
	updateLabel(signRessource.get_star_count())
	
func updateLabel(count: int):
	text = "Stars: " + str(count)
