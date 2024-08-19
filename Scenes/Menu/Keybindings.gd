extends Node2D

@onready var bindings = $ScrollContainer/Bindings

var selectedBinding = null

func _ready():
	var all_ies = _get_mapping()
	for opt in bindings.get_children():
		opt.EditPressed.connect(_a)
		
		if opt.inputMapName in all_ies.values():
			var x = all_ies.find_key(opt.inputMapName)
			if x:
				opt.update_key(x.replace("(Physical)", ""))
	
func _on_back_button_pressed():# TODO: add escape
	get_tree().change_scene_to_file(SceneManger.MenuSceneKey)
	
func _input(event: InputEvent) -> void: #TODO: check if key already mapped! 
	if !selectedBinding: # return if none selected
		return
		
	if event is InputEventKey || event is InputEventMouseButton:
		var all_ies = _get_mapping()
		
		if all_ies.keys().has(event.as_text()):
			InputMap.action_erase_events(all_ies[event.as_text()])
		
		InputMap.action_erase_events(selectedBinding)
		InputMap.action_add_event(selectedBinding, event)
	
		_update_UI(selectedBinding, event)
		selectedBinding = null
		for opt in bindings.get_children():
			opt.activate()

func _a(name):
	for opt in bindings.get_children():
		opt.deactivate()
	selectedBinding = name
	
func _update_UI(binding, event):
	'''[ &"Move_Left", &"Move_Right", &"Move_Forward", &"Move_Backward",
	 , &"UI_Zoom_In", &"UI_Zoom_Out",]'''
	for opt in bindings.get_children():
		if opt.inputMapName == binding:
			var key = InputMap.action_get_events(binding)[0]
			opt.update_key(key.as_text())

func _get_mapping() -> Dictionary:
	var all_ies : Dictionary = {}
	for ia in InputMap.get_actions():
		for iae in InputMap.action_get_events(ia):
			all_ies[iae.as_text()] = str(ia)
	return all_ies
