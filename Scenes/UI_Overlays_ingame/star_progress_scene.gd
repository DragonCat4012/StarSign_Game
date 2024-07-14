extends TextureRect

@onready var progressBar = $ProgressBar2
@onready var timer = $ProgressBar2/Timer
@onready var damageBar = $ProgressBar2/DamageBar

var progress = 0

func _ready():
	EventSystem.IncreaseStarCountProgress.connect(_increase)
	EventSystem.DecreaseStarCountProgress.connect(_decrease)
	var data = GameManager.INVENTORY._init_progress_bar_data()
	_init_default(data.y)
	_init_max(data.x)
	
func _increase():
	#print("increase")
	update_progress(progress+1)
	
func _decrease():
	update_progress(progress-1)
	
func _init_max(max: int):
	#print("init max ", max)
	progressBar.max_value = max
	damageBar.max_value = max
	
func _init_default(value: int):
	#print("init default ", value)
	progressBar.value = value
	damageBar.value = 0
	progress = value
	
func update_progress(new_value: int):
	#print("update star progress: ", new_value)
	var prev_progress = progressBar.value
	damageBar.value = min(progressBar.max_value, new_value)
	
	if new_value > prev_progress: # increased
		timer.start()
	else: # reduced
		pass
	progress = new_value

func _on_timer_timeout():
	damageBar.value = 0
	progressBar.value = min(progressBar.max_value, progress)
