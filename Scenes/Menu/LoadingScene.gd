extends Control
class_name LoadingSceneClass

@onready var progressLabel := $Progress

var nextSceneName = ""
var progress = []
var load_status = 0

func _ready():
	nextSceneName = SceneManger.NEXTSCENE_AFTERLOADING
	SceneManger.NEXTSCENE_AFTERLOADING = ""
	print(nextSceneName)
	ResourceLoader.load_threaded_request(nextSceneName)

func _process(delta):
	load_status = ResourceLoader.load_threaded_get_status(nextSceneName, progress)
	progressLabel.text = str(floor(progress[0]*100)) + "%"
	
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(nextSceneName)
		get_tree().change_scene_to_packed(newScene)
