extends Area3D

signal starCollected 

func _physics_process(delta):
	rotate_y(deg_to_rad(3))

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("starCollected")
		print("Star collected")
		$Timer.start()

func _on_timer_timeout():
	queue_free()
