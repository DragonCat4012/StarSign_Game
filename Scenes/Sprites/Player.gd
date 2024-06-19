extends RigidBody3D

@onready var twistPivot = $TwistPivot
@onready var pitchPivot = $TwistPivot/PitchPivot

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _process(delta: float):
	var input = Vector3.ZERO
	input.x = Input.get_axis("Move_Left", "Move_Right")
	input.z = Input.get_axis("Move_Forward", "Move_Backward")
	apply_central_force(twistPivot.basis * input * 1200 * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	twistPivot.rotate_y(twist_input)
	pitchPivot.rotate_x(pitch_input)
	
#	$TwistPivot.rotation.y = clamp($TwistPivot.rotation.y,	-0.5, 0.5)
	pitchPivot.rotation.x = clamp(pitchPivot.rotation.x, deg_to_rad(-30), deg_to_rad(30))
	twist_input = 0.0
	pitch_input = 0.0
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
