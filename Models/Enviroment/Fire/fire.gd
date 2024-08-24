extends Node3D
@onready var smoke = $Smoke
@onready var amber = $Amber
@onready var fire = $Fire

func _ready():
	EventSystem.PauseEnded.connect(_start_particles)
	EventSystem.PauseStared.connect(_freeze_particles_particles)
	
func _freeze_particles_particles():
	fire.material_override.set_shader_parameter("FireActivity", 0.0)
	smoke.speed_scale = 0
	amber.speed_scale = 0

func _start_particles():
	fire.material_override.set_shader_parameter("FireActivity", 1.0)
	smoke.speed_scale = 1
	amber.speed_scale = 1
