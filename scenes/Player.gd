extends KinematicBody2D

var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 140
var horizontalAcceleration = 2000
var jumpSpeed = 360
var jumpMultiplier = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


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
	if (moveVector.y < 0 && is_on_floor()):
		velocity.y = moveVector.y * jumpSpeed

	# jump variability 
	# if you're going up and not holding the jump key
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * delta * jumpMultiplier 
	else:
		velocity.y += gravity * delta
		
	# takes an input vector, moves the character by vector * delta - resets velocity to 0 after collision
	velocity = move_and_slide(velocity, Vector2.UP)

func get_movement_vector():
	var moveVector = Vector2.ZERO
	# will return either 0 or 1 
	# jump - 1 --> we want to go up on the y axis
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if  Input.is_action_just_pressed("jump") else 0 
	return moveVector
