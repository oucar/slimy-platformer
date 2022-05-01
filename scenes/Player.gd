extends KinematicBody2D

var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 140
var horizontalAcceleration = 2000
var jumpSpeed = 360
var jumpMultiplier = 4
var hasDoubleJump = false

# signals
signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get hazardArea node, connect area_entered, listen for self and call on_hazard_area_entered!
	# Make sure you set the collision layer and mask too!
	get_node("HazardArea").connect("area_entered", self, "on_hazard_area_entered")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	
	update_animation()

func get_movement_vector():
	var moveVector = Vector2.ZERO
	# will return either 0 or 1 
	# jump - 1 --> we want to go up on the y axis
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if  Input.is_action_just_pressed("jump") else 0 
	return moveVector

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
			
func on_hazard_area_entered(area2d):
	# print("You would die, but this is your lucky day.")
	emit_signal("died")
