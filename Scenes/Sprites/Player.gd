extends RigidBody3D

var mouse_sensitivity := 0.001
var twist_input:= 0.0
var pitch_input := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _process(delta: float):
	var input = Vector3.ZERO
	input.x = Input.get_axis("Move_Left", "Move_Right")
	input.z = Input.get_axis("Move_Forward", "Move_Backward")
	apply_central_force(input * 1200 * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
