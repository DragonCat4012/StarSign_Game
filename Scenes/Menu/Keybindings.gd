extends Node2D

@onready var bindings = $ScrollContainer/Bindings

var selectedBinding = null
var currentBinding = null

var key_options = []
var takenKeys = []

func _ready():
	key_options = bindings.get_children().filter(func(e): return e is HBoxContainer)
	var all_ies = _get_mapping()
	for opt in key_options:
		opt.EditPressed.connect(_a)
		
		if opt.inputMapName in all_ies.values():
			var x = all_ies.find_key(opt.inputMapName)
			if x:
				opt.update_key(x.replace("(Physical)", ""))
				takenKeys.append(x.replace("(Physical)", ""))
	
func _on_back_button_pressed():
	get_tree().change_scene_to_file(SceneManger.MenuSceneKey)
	
func _input(event: InputEvent) -> void:
	if !selectedBinding:
		if event.is_action_pressed("ui_cancel"):
			get_tree().change_scene_to_file(SceneManger.MenuSceneKey)
		return
		
	if event is InputEventKey || event is InputEventMouseButton:
		var all_ies = _get_mapping()
		
		if all_ies.keys().has(event.as_text()):
			if event.as_text() in takenKeys and event.as_text() != currentBinding:
				print(currentBinding, event.as_text())
				print("nonono already taken")
				return
			InputMap.action_erase_events(all_ies[event.as_text()])
		
		InputMap.action_erase_events(selectedBinding)
		InputMap.action_add_event(selectedBinding, event)
	
		_update_UI(selectedBinding, event)
		selectedBinding = null
		currentBinding = null
		for opt in key_options:
			opt.activate()

func _a(name, binding):
	for opt in key_options:
		opt.deactivate()
	selectedBinding = name
	currentBinding = binding
	
func _update_UI(binding, event):
	for opt in key_options:
		if opt.inputMapName == binding:
			var key = InputMap.action_get_events(binding)[0]
			opt.update_key(key.as_text())

func _get_mapping() -> Dictionary:
	var all_ies : Dictionary = {}
	for ia in InputMap.get_actions():
		for iae in InputMap.action_get_events(ia):
			all_ies[iae.as_text()] = str(ia)
	return all_ies
