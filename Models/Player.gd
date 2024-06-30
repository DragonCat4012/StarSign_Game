extends CharacterBody3D

@onready var armature := $Armature
@onready var spring_arm_pivot := $TwistPivot
@onready var spring_arm := $TwistPivot/SpringArm3D
@onready var animation_tree := $AnimationTree
@onready var jumpParticleEmitter := $GPUParticles3D

# Turning Camera
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

# Jumping
const SPEED = 8.0
var isJumping = false
var jump_count = 0
var timer := Timer.new()

const Jump_Velocity = 5.1
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Turning
const LERP_VAL = 0.15

# Weapons
@onready var weaponNode := $Armature/Skeleton3D/HandAttachment/HandContainer

# Emotes
var emoteIndex = 0
var emoteAnimations = ["reaction_disappoint", "reaction_looking_around"]
var isEmoteAnimationPlaying = false

# Compass
var compassDirection = 0

func _ready():
	add_child(timer)
	timer.wait_time = 0.4
	timer.connect("timeout", _on_timer_timeout)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	GameManager.showWeaponById.connect(_on_game_scene_activate_weapon)
	GameManager.showWeapon.connect(_on_game_scene_show_weapon)
	GameManager.hideWeapon.connect(_on_game_scene_hide_weapon)
	
func _process(delta: float):
	spring_arm_pivot.rotate_y(twist_input)
	spring_arm.rotate_x(pitch_input)
	
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-30), deg_to_rad(30))
	twist_input = 0.0
	pitch_input = 0.0
		
	compassDirection = $TwistPivot/SpringArm3D/Camera3D.global_rotation_degrees.y
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

func _physics_process(delta):
	isJumping = !is_on_floor()
	if $AnimationPlayer.current_animation == emoteAnimations[emoteIndex]: # dont move during emote
		return 
	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_on_floor():
		jump_count = 0
		if Input.is_action_just_pressed("Attack1"):
			$AnimationPlayer.play(_select_attack_1_animation())
		elif Input.is_action_just_pressed("Attack2"):
			$AnimationPlayer.play(_select_attack_2_animation())
		elif Input.is_action_just_pressed("Player_Reaction"):
			isEmoteAnimationPlaying = true
			$AnimationPlayer.play(_display_emotion())
			$AnimationPlayer.animation_finished.connect(_finished_emotion_animation)
			velocity = Vector3(0,0,0) # dont move after animation
			return
	
	if Input.is_action_just_pressed("Move_Jump") and jump_count < 2:
		jump_count += 1
		_jump_particles()
		isJumping = true
		velocity.y = Jump_Velocity
	
	var input_dir = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
	
	if not isJumping:
		$AnimationPlayer.speed_scale = 1
		animation_tree.set("parameters/BlendSpace1D/blend_position", velocity.length()/SPEED)
	else:
		$AnimationPlayer.speed_scale = 1.5
		$AnimationPlayer.play("jump")
		animation_tree.set("parameters/BlendSpace1D/blend_position", -1)
	move_and_slide()

# Jump animations
func _jump_particles():
	jumpParticleEmitter.emitting = true
	timer.start()

func _on_timer_timeout() -> void:
	if jumpParticleEmitter.emitting:
		jumpParticleEmitter.emitting = false

# weapon Switching
func _on_game_scene_show_weapon():
	get_weapon_children(true)
	
func _on_game_scene_activate_weapon():
	for child in weaponNode.get_children():
		child.visible = false
	get_weapon_children(true)

func _on_game_scene_hide_weapon():
	get_weapon_children(false)

func get_weapon_children(newVisible: bool):
	for c in weaponNode.get_children():
		if c.name == str(GameManager.selectedWeaponId):
			c.visible = newVisible	

func _select_attack_1_animation() -> String:
	if not GameManager.weaponactive: # default attack when no weapon
		return "attack_base"
	if not GameManager.currentWeapon: # No weapon selected use base attack
		return "attack_base"
	
	return GameManager.currentWeapon.animation1Name

func _select_attack_2_animation() -> String:
	if not GameManager.weaponactive: # default attack when no weapon
		return "attack_forward"
	if not GameManager.currentWeapon: # No weapon selected use base attack
		return "attack_forward"
	
	return GameManager.currentWeapon.animation2Name

# Emotions
func _display_emotion() -> String:
	emoteIndex += 1 
	emoteIndex = emoteIndex % emoteAnimations.size()
	return emoteAnimations[emoteIndex]

func _finished_emotion_animation():
	isEmoteAnimationPlaying = false
