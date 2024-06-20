extends Label

var stars := 0

func _ready():
	updateLabel()

func _on_star_star_collected():
	stars += 1
	updateLabel()

func updateLabel():
	text = "Stars: " + str(stars)
