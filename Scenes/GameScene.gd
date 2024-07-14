extends Node3D
@onready var lightSource = $DirectionalLight3D


func _ready():
	lightSource.rotation_degrees.x = -170 # Init to day
	
func _physics_process(delta):
	if $Player.position.y < -75:
		Log.info("Player died due to height :c")
		get_tree().change_scene_to_file(SceneManger.MenuSceneKey)

func _process(delta: float):
	lightSource.rotate_x(deg_to_rad(GameManager.TIME_PER_DAY))

	if lightSource.rotation_degrees.x > 0: # Night
		lightSource.light_energy = 0.01
	else:
		lightSource.light_energy = 1.0 # Day
