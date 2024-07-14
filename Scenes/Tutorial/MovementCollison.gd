extends Area3D

func _ready() -> void:
	body_entered.connect(_on_Area_body_entered)

func _on_Area_body_entered(body:Node) -> void:
	if body.name == "Player":
		EventSystem.signal_tutorial_enetred_movement_test()
