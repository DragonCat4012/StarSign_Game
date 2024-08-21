extends Node3D
@onready var animation_player = $AnimationPlayer
@onready var gpu_particles_3d = $GPUParticles3D
@onready var flower_waves = $FlowerWaves


func _on_trigger_body_entered(body):
	if body.name == "Player":
		gpu_particles_3d.emitting = true
		animation_player.play("fade_in")
		flower_waves.get_active_material(0).set_shader_parameter("speed", Vector2(-0.1,-0.1))
		
func _on_trigger_body_exited(body):
	if body.name == "Player":
		animation_player.play("fade_out")
		gpu_particles_3d.emitting = false
		flower_waves.get_active_material(0).set_shader_parameter("speed", Vector2(0.0,0.0))
