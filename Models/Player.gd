extends CharacterBody3D

@onready var armature = $Armature
@onready var spring_arm_pivot = $TwistPivot
@onready var spring_arm = $TwistPivot/SpringArm3D
@onready var animation_tree = $AnimationTree

# Turning Camera
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

# Jumping
const SPEED = 5.0

const Jump_Velocity = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Turning
const LERP_VAL = 0.15

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	spring_arm_pivot.rotate_y(twist_input)
	spring_arm.rotate_x(pitch_input)
	
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-30), deg_to_rad(30))
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
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)#move_toward(velocity.x, 0, SPEED)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)#move_toward(velocity.z, 0, SPEED)
		
	animation_tree.set("parameters/BlendSpace1D/blend_position", velocity.length()/SPEED)
	move_and_slide()
