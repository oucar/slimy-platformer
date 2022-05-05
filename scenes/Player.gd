extends KinematicBody2D

# signals
signal died

var playerDeathScene = preload("res://scenes/PlayerDeath.tscn")

export(int, LAYERS_2D_PHYSICS) var dashHazardMask

# finite state 
enum State { NORMAL, DASH}

var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 140
var maxDashSpeed = 500
var minDashSpeed = 200
var horizontalAcceleration = 2000
var jumpSpeed = 320
var jumpMultiplier = 4
var hasDoubleJump = false
var hasDash
var isStateNew = true
var currentState = State.NORMAL
var defaultHazardMask = 0
var isDying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get hazardArea node, connect area_entered, listen for self and call on_hazard_area_entered!
	# Make sure you set the collision layer and mask too!
	get_node("HazardArea").connect("area_entered", self, "on_hazard_area_entered")
	defaultHazardMask = get_node("HazardArea").collision_mask

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		State.NORMAL:
			_process_normal(delta)
		State.DASH:
			_process_dash(delta)
			isStateNew = false
	
###### MOVEMENT RELATED ###### 
func get_movement_vector():
	var moveVector = Vector2.ZERO
	# will return either 0 or 1 
	# jump - 1 --> we want to go up on the y axis
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if  Input.is_action_just_pressed("jump") else 0 
	return moveVector

# movement -process- functions for normal movement (running) and dash (dashing)
func _process_normal(delta):
	if(isStateNew):
		get_node("DashArea/CollisionShape2D").disabled = true
		get_node("HazardArea").collision_mask = defaultHazardMask
	var moveVector = get_movement_vector()
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	# deacceleration
	if(moveVector.x == 0):
		# https://www.gamedeveloper.com/programming/improved-lerp-smoothing-
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	# we want to jump
	if (moveVector.y < 0 && (is_on_floor() || !get_node("CoyoteTimer").is_stopped() || hasDoubleJump)):
		velocity.y = moveVector.y * jumpSpeed
		# recently jumped, set doublejump to false
		if(!is_on_floor()  && get_node("CoyoteTimer").is_stopped()):
			hasDoubleJump = false
			# shake the camera when double jumping
			get_tree().get_root().get_node("Helpers").apply_camera_shake(0.75)
		# stop the coyote jump when jumping (Required for double jump)tile_0151.pngtile_0152.png
		get_node("CoyoteTimer").stop()

	# jump variability 
	# if you're going up and not holding the jump key
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * delta * jumpMultiplier 
	else:
		velocity.y += gravity * delta
	
	var wasOnFloor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# coyote time
	if(wasOnFloor && !is_on_floor()):
		get_node("CoyoteTimer").start()
		
	# double jump 
	if(is_on_floor()):
		hasDoubleJump = true
		hasDash = true
		
	# dash
	if(hasDash && Input.is_action_just_pressed("dash")):
		# multithreading - will be called after everything is done
		call_deferred("change_state", State.DASH)
		hasDash = false
	
	update_animation()

# dash movement
func _process_dash(delta):
	if(isStateNew == true):
		# shake the camera
		get_tree().get_root().get_node("Helpers").apply_camera_shake(1)
		get_node("DashArea/CollisionShape2D").disabled = false
		get_node("HazardArea").collision_mask = dashHazardMask
		get_node("AnimatedSprite").play("jump")
		var moveVector = get_movement_vector()
		var facingDirection = 1
		# dashing when moving
		if(moveVector.x != 0):
			facingDirection = sign(moveVector.x)
		# dashing when stationary
		else: 
			if(get_node("AnimatedSprite").flip_h == true):
				print("facing right when dashing")
			else: 
				print("facing left when dashing")
				facingDirection = -1
		# x direction, y direction
		velocity = Vector2(maxDashSpeed * facingDirection, 0)
		
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -10 * delta))

	# abs required because of the facing direction
	if(abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.NORMAL)
		
func change_state(newState):
	currentState = newState
	isStateNew = true
	

###### UPDATING THE ANIMATION ###### 
func update_animation():
	# get the current movement vector
	var curMovementVector = get_movement_vector()
	
	if(!is_on_floor()):
		get_node("AnimatedSprite").play("jump")
	elif (curMovementVector.x != 0):
		get_node("AnimatedSprite").play("run")
	else:
		get_node("AnimatedSprite").play("idle")
		
	if(curMovementVector.x != 0):
		if(curMovementVector.x > 0):
			get_node("AnimatedSprite").flip_h = true
		else:
			get_node("AnimatedSprite").flip_h = false
				
###### PLAYER DEATH ANIMATION ###### 
func kill():
	# if you land the intersection of two spikes, kill() gets called twice.
	# use isDying to prevent calling it twice
	if(isDying == true):
		return 
	isDying = true
	# print("You would die, but this is your lucky day.")
	# get_node("BloodSplatter").splatter()
	var playerDeathInstance = playerDeathScene.instance()
	get_parent().add_child_below_node(self, playerDeathInstance)
	playerDeathInstance.global_position = global_position
	playerDeathInstance.velocity = velocity
	emit_signal("died")
	
###### SIGNAL RELATED ###### 
func on_hazard_area_entered(_area2d):
	call_deferred("kill")
	
