extends CharacterBody3D

@onready var twistPivot = $TwistPivot
@onready var pitchPivot = $TwistPivot/PitchPivot

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

const Speed = 5.0
const Jump_Velocity = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float):
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

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("Move_Jump") and is_on_floor():
		velocity.y = Jump_Velocity
	
	var input_dir = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	var direction = (twistPivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * Speed
		velocity.z = direction.z * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.z = move_toward(velocity.z, 0, Speed)
		
	move_and_slide()
