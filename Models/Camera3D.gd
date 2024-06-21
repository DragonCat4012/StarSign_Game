extends Camera3D

var maxZoom = 110
var defaultZoom = 75
var minZoom = 25
var zoomSteps = 5

func _physics_process(delta):
	zoom()
	
func zoom():
	if Input.is_action_just_released('UI_Zoom_In'):
		set_fov(clamp(fov-zoomSteps, minZoom, defaultZoom))
	if Input.is_action_just_released('UI_Zoom_Out'): 
		set_fov(clamp(fov+zoomSteps, defaultZoom, maxZoom))
	if Input.is_action_just_released('UI_Zoom_Reset'):
		set_fov(defaultZoom)
