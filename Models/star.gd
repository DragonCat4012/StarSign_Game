extends Area3D

@export var star: Star = preload("res://Ressources/Stars/Stars/Aries/star0.tres")

func _physics_process(delta):
	rotate_y(deg_to_rad(3))

func _on_body_entered(body):
	if body.name == "Player":
		EventSystem.StarCollect.emit(star.starId)
		print("Star collected (from star) id: ", star.starId)
		$Timer.start()

func _on_timer_timeout():
	queue_free()
