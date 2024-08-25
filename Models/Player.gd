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

# Stairs
const MAX_STEP_HEIGHT = 1
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF

func _ready():
	get_weapon_children(true) # TODO: load from save file
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
	if is_on_floor(): _last_frame_was_on_floor = Engine.get_physics_frames()
	
	isJumping = !is_on_floor()
	if $AnimationPlayer.current_animation == emoteAnimations[emoteIndex]: # dont move during emote
		return 
	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_on_floor() or _snapped_to_stairs_last_frame:
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
	
	animation_tree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor())
	animation_tree.set("parameters/conditions/walking", input_dir != Vector2.ZERO && is_on_floor())
	animation_tree.set("parameters/conditions/jumping", !is_on_floor())
	animation_tree.set("parameters/conditions/landing", is_on_floor())
	
	if not _snap_up_stairs_check(delta):
		move_and_slide()
		_snap_down_to_stairs_check()

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
		c.visible = false
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

# Stairs
func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

func _run_body_test_motion(from: Transform3D, motion: Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func _snap_down_to_stairs_check():
	var did_snap := false
	var floor_below: bool = %StairsBelowRayCast.is_colliding() and not is_surface_too_steep(%StairsBelowRayCast.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0, -MAX_STEP_HEIGHT, 0), body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1)*delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT*2, 0))
	var down_check_result = PhysicsTestMotionResult3D.new()
	if(_run_body_test_motion(step_pos_with_clearance, Vector3(0, -MAX_STEP_HEIGHT*2, 0), down_check_result) 
	and (down_check_result.get_collider().is_class("StaticBody3d") or down_check_result.get_collider().is_class("CGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_collision_point() - self.global_position).y > MAX_STEP_HEIGHT: return false
		%StairsAheadRayCast.global_position = down_check_result.get_collision_point() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized()*0.1
		%StairsAheadRayCast.force_raycast_update()
		if %StairsAheadRayCast.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false
